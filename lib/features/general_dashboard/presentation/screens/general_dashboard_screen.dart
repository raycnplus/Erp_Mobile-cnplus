import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/presentation/controllers/general_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/models/general_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/presentation/widgets/general_dashboard_bar_chart.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';

class GeneralDashboardScreen extends StatelessWidget {
  const GeneralDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<GeneralDashboardController>(),
      child: const _GeneralDashboardBody(),
    );
  }
}

class _GeneralDashboardBody extends StatefulWidget {
  const _GeneralDashboardBody();

  @override
  State<_GeneralDashboardBody> createState() => _GeneralDashboardBodyState();
}

class _GeneralDashboardBodyState extends State<_GeneralDashboardBody> {
  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<GeneralDashboardController>().load(),
    );
  }

  String _fmtShort(double v) {
    if (v >= 1000000) return 'Rp${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return 'Rp${(v / 1000).toStringAsFixed(1)}k';
    return 'Rp${v.toStringAsFixed(0)}';
  }

  Future<void> _pickDateRange(GeneralDashboardController ctrl) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(start: ctrl.startDate, end: ctrl.endDate),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: colorPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      ctrl.load(startDate: picked.start, endDate: picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'General Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 18,
          ),
        ),
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        elevation: 0.5,
      ),
      drawer: const UniversalDrawer(currentModule: AppModule.general),
      body: Consumer<GeneralDashboardController>(
        builder: (_, ctrl, __) {
          if (ctrl.state == GeneralDashboardState.loading) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.state == GeneralDashboardState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(ctrl.error ?? 'Error',
                        style: GoogleFonts.poppins(color: colorError),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: ctrl.load,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.data == null) return const SizedBox();

          final d = ctrl.data!;
          return RefreshIndicator(
            color: colorPrimary,
            onRefresh: () => ctrl.load(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _DateFilter(
                  startDate: ctrl.startDate,
                  endDate: ctrl.endDate,
                  dateFormat: _dateFormat,
                  onTap: () => _pickDateRange(ctrl),
                ),
                const SizedBox(height: 20),

                const _SectionHeader(
                  title: 'Sales',
                  icon: Icons.trending_up_outlined,
                  color: Color(0xFFF97316),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Revenue',
                        value: _fmtShort(d.sales.summary.revenue),
                        icon: Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'Orders',
                        value: '${d.sales.summary.orders}',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StatCard(
                  title: 'Avg Order Value',
                  value: _fmtShort(d.sales.summary.aov),
                  icon: Icons.bar_chart_outlined,
                ),
                const SizedBox(height: 16),
                _LineChartCard(
                  title: 'Sales Trend',
                  labels: d.sales.revenueTrend.labels,
                  values: d.sales.revenueTrend.values,
                  color: const Color(0xFFF97316),
                  fmtShort: _fmtShort,
                ),
                const SizedBox(height: 12),
                GeneralBarChart(
                  title: 'Top 5 Products',
                  labels: d.sales.topProducts.map((p) => p.productName).toList(),
                  values: d.sales.topProducts.map((p) => p.revenue).toList(),
                  color: const Color(0xFFF97316),
                ),
                const SizedBox(height: 12),
                _RecentOrdersCard(orders: d.sales.recentOrders, fmtShort: _fmtShort),
                const SizedBox(height: 24),

                _SectionHeader(
                  title: 'Inventory & Supply Chain',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blueAccent.shade700,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Stock Value',
                        value: _fmtShort(d.inventory.summary.stockValue),
                        icon: Icons.warehouse_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'Turnover',
                        value: d.inventory.summary.turnoverRatio.toStringAsFixed(1),
                        icon: Icons.autorenew,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StatCard(
                  title: 'Low Stock Items',
                  value: '${d.inventory.summary.lowStockCount}',
                  icon: Icons.warning_amber_outlined,
                ),
                const SizedBox(height: 16),
                _StockInOutCard(trend: d.inventory.movementTrend),
                const SizedBox(height: 24),

                _SectionHeader(
                  title: 'Purchase',
                  icon: Icons.shopping_cart_outlined,
                  color: Colors.green.shade800,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Vendor Spend',
                        value: _fmtShort(d.purchase.summary.vendorSpend),
                        icon: Icons.store_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'PO Cycle',
                        value: '${d.purchase.summary.poCycleTimeDays}d',
                        icon: Icons.timer_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GeneralBarChart(
                  title: 'Top 5 Vendors',
                  labels: d.purchase.topVendors.labels,
                  values: d.purchase.topVendors.values,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DateFilter extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const _DateFilter({
    required this.startDate,
    required this.endDate,
    required this.dateFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: colorPrimary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${dateFormat.format(startDate)}  →  ${dateFormat.format(endDate)}',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: colorPrimary, borderRadius: BorderRadius.circular(8)),
              child: Text('Filter',
                  style: GoogleFonts.poppins(
                      color: colorWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          ),
        ],
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<double> values;
  final Color color;
  final String Function(double) fmtShort;

  const _LineChartCard({
    required this.title,
    required this.labels,
    required this.values,
    required this.color,
    required this.fmtShort,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorTextPrimary)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: values.isEmpty
                  ? Center(
                      child: Text('No data',
                          style: GoogleFonts.poppins(color: colorGrey)))
                  : LineChart(_buildData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildData() {
    final spots = values.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final maxY = values.reduce((a, b) => a > b ? a : b);

    return LineChartData(
      minY: 0,
      maxY: maxY * 1.2,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: colorGreyLight, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 52,
            getTitlesWidget: (v, _) => Text(fmtShort(v),
                style: GoogleFonts.poppins(fontSize: 9, color: colorTextSubtle)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= labels.length) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(labels[idx].split(' ').first,
                    style: GoogleFonts.poppins(
                        fontSize: 9, color: colorTextSubtle)),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 2.5,
          dotData: FlDotData(show: spots.length <= 12),
          belowBarData:
              BarAreaData(show: true, color: color.withOpacity(0.08)),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (ts) => ts.map((s) {
            final lbl =
                s.x.toInt() < labels.length ? labels[s.x.toInt()] : '';
            return LineTooltipItem('$lbl\n${fmtShort(s.y)}',
                GoogleFonts.poppins(fontSize: 11, color: Colors.white));
          }).toList(),
        ),
      ),
    );
  }
}

class _StockInOutCard extends StatelessWidget {
  final MovementTrend trend;
  const _StockInOutCard({required this.trend});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock In vs Stock Out',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorTextPrimary)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: trend.labels.isEmpty
                  ? Center(
                      child: Text('No data',
                          style: GoogleFonts.poppins(color: colorGrey)))
                  : LineChart(_buildData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildData() {
    final spotsIn = trend.qtyIn.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final spotsOut = trend.qtyOut.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final allV = [...trend.qtyIn, ...trend.qtyOut];
    final maxY =
        allV.isNotEmpty ? allV.reduce((a, b) => a > b ? a : b) : 10.0;

    return LineChartData(
      minY: 0,
      maxY: maxY * 1.2,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: colorGreyLight, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                style:
                    GoogleFonts.poppins(fontSize: 9, color: colorTextSubtle)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= trend.labels.length) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(trend.labels[idx].split(' ').first,
                    style: GoogleFonts.poppins(
                        fontSize: 9, color: colorTextSubtle)),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spotsIn,
          isCurved: true,
          color: const Color(0xFF228B22),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF228B22).withOpacity(0.08)),
        ),
        LineChartBarData(
          spots: spotsOut,
          isCurved: true,
          color: const Color(0xFFF30A0A),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFF30A0A).withOpacity(0.08)),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots.map((s) {
            final lbl = s.x.toInt() < trend.labels.length
                ? trend.labels[s.x.toInt()]
                : '';
            final name = s.barIndex == 0 ? 'In' : 'Out';
            return LineTooltipItem('$lbl\n$name: ${s.y.toStringAsFixed(0)}',
                GoogleFonts.poppins(fontSize: 11, color: Colors.white));
          }).toList(),
        ),
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  final List<RecentOrder> orders;
  final String Function(double) fmtShort;

  const _RecentOrdersCard({required this.orders, required this.fmtShort});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Recent Orders',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                  child: Text('No data available',
                      style:
                          GoogleFonts.poppins(color: Colors.grey.shade500))),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 16,
                headingRowColor: WidgetStateProperty.resolveWith(
                    (_) => colorPrimary.withOpacity(0.05)),
                columns: [
                  DataColumn(
                      label: Text('Ref',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13))),
                  DataColumn(
                      label: Text('Customer',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13))),
                  DataColumn(
                      label: Text('Amount',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13))),
                  DataColumn(
                      label: Text('Status',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13))),
                ],
                rows: orders.map((o) {
                  return DataRow(cells: [
                    DataCell(SizedBox(
                        width: 90,
                        child: Text(o.reference,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: colorTextPrimary),
                            overflow: TextOverflow.ellipsis))),
                    DataCell(SizedBox(
                        width: 130,
                        child: Text(o.customerName,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: colorTextSubtle),
                            overflow: TextOverflow.ellipsis))),
                    DataCell(Text(fmtShort(o.untaxedAmount),
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorPrimary))),
                    DataCell(_StatusBadge(status: o.status)),
                  ]);
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Done' => Colors.green,
      'Confirmed' => Colors.blue,
      'Draft' => Colors.grey,
      _ => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status,
          style: GoogleFonts.poppins(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}