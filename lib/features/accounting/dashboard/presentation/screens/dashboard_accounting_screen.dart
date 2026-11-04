import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/controllers/accounting_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_dashboard_shimmer.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_bar_chart_widget.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_aging_card.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_kpi_card.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_financial_chart.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/widgets/accounting_top_customer_card.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';

class DashboardAccountingScreen extends StatefulWidget {
  const DashboardAccountingScreen({super.key});

  @override
  State<DashboardAccountingScreen> createState() => _DashboardAccountingScreenState();
}

class _DashboardAccountingScreenState extends State<DashboardAccountingScreen> {
  late AccountingDashboardController _controller;
  late ScrollController _scrollController;
  bool _isChartView = false; 
  int _selectedChart = 0;    

  final Alignment _initialTitleAlignment = const Alignment(-0.6, 0.0);
  final Alignment _scrolledTitleAlignment = const Alignment(-1.20, 0.0);
  final TextStyle _initialTitleStyle = GoogleFonts.poppins(
    color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600,
  );
  final TextStyle _scrolledTitleStyle = GoogleFonts.poppins(
    color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600,
  );
  final double _initialIconSize = 28.0;
  final double _scrolledIconSize = 24.0;
  final double _scrollThreshold = 50.0;

  static const Color _themeColor = Color(0xFF029379);
  final _dateFormat = DateFormat('dd MMM yyyy');

  static const Map<String, int> _ratios = {'ROA': 56, 'ROI': 70, 'ROE': 64};

  @override
  void initState() {
    super.initState();
    _controller = getIt<AccountingDashboardController>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadDashboard();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _controller.startDate,
        end: _controller.endDate,
      ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _themeColor),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _controller.updateDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountingDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.accounting),
        ),
        body: Consumer<AccountingDashboardController>(
          builder: (context, controller, _) {
            if (controller.status == AccountingDashboardStatus.error) {
              return _buildErrorState(controller);
            }
            if (controller.status == AccountingDashboardStatus.loading) {
              return const AccountingDashboardShimmer();
            }
            if (controller.status == AccountingDashboardStatus.loaded && controller.hasData) {
              return _buildDashboardContent(controller);
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final progress = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0) : 0.0;
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.black,
                size: lerpDouble(_initialIconSize, _scrolledIconSize, progress)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final progress = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0) : 0.0;
          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.lerp(
                  _initialTitleAlignment, _scrolledTitleAlignment, progress)!,
              child: Text('Dashboard Accounting',
                  style: TextStyle.lerp(
                      _initialTitleStyle, _scrolledTitleStyle, progress)!),
            ),
          );
        },
      ),
      actions: [
        AnimatedBuilder(
          animation: _scrollController,
          builder: (context, _) {
            final progress = _scrollController.hasClients
                ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0) : 0.0;
            return IconButton(
              icon: Icon(Icons.person_outline, color: Colors.black,
                  size: lerpDouble(_initialIconSize, _scrolledIconSize, progress)),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen())),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildErrorState(AccountingDashboardController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(controller.errorMessage ?? 'An error occurred',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.loadDashboard(),
            style: ElevatedButton.styleFrom(backgroundColor: _themeColor),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(AccountingDashboardController controller) {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: _themeColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFormat.format(controller.startDate)}  →  ${_dateFormat.format(controller.endDate)}',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: _themeColor, borderRadius: BorderRadius.circular(8)),
              child: const Text('Filter',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _themeColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _themeColor : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: _themeColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4))]
              : [BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2))],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Row(
      children: [
        Expanded(child: _buildPill('Detailed', !_isChartView, () => setState(() => _isChartView = false))),
        const SizedBox(width: 10),
        Expanded(child: _buildPill('Chart', _isChartView, () => setState(() => _isChartView = true))),
      ],
    );
  }

  Widget _buildChartToggleButtons() {
    return Row(
      children: [
        Expanded(child: _buildPill('Top 5 Revenue', _selectedChart == 0, () => setState(() => _selectedChart = 0))),
        const SizedBox(width: 10),
        Expanded(child: _buildPill('Top 5 Expense', _selectedChart == 1, () => setState(() => _selectedChart = 1))),
      ],
    );
  }

  List<AccountingChartData> _transformToChartData(List<TopListData> items, Color? color) {
    return items
        .map((item) => AccountingChartData(label: item.title, value: item.amount, color: color))
        .toList();
  }

  Widget _buildTopTable(String title, List<TopListData> items, Color accent) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('No data available',
                      style: GoogleFonts.poppins(color: Colors.grey.shade500)),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => accent.withOpacity(0.05),
                  ),
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Reference')),
                    DataColumn(label: Text('Total Amount')),
                  ],
                  rows: List.generate(items.length, (index) {
                    final item = items[index];
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              item.title,
                              style: GoogleFonts.poppins(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatCurrency(item.amount),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartWithHint(String key, List<AccountingChartData> data, String title) {
    return Column(
      key: ValueKey(key),
      children: [
        AccountingBarChart(data: data, title: title),
        const SizedBox(height: 8),
        Text(
          "Tap a bar for more details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildRatioCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.pie_chart_outline, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Ratio',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: _ratios.entries.map((e) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(e.key,
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        '${e.value}%',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _themeColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(AccountingDashboardController controller) {
    final data = controller.dashboardData!;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: _themeColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 16),

            _buildDateFilter(controller),
            const SizedBox(height: 12),

            _buildViewToggle(),
            const SizedBox(height: 16),

            if (_isChartView) ..._buildChartView(data) else ..._buildDetailedView(data),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailedView(AccountingDashboardResponse data) {
    final summary = data.summary;
    final topRevenueData = _transformToChartData(data.topRevenue, _themeColor);
    final topExpenseData = _transformToChartData(data.topExpense, Colors.red);

    return [
      Row(
        children: [
          Expanded(
            child: StatCard(
              title: "Current Income",
              value: formatCurrency(summary.totalInvoice),
              icon: Icons.attach_money,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: "Receivables",
              value: formatCurrency(summary.totalSalesOrder),
              icon: Icons.receipt_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: StatCard(
              title: "Current Expense",
              value: formatCurrency(summary.totalBill),
              icon: Icons.trending_down,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: "Payables",
              value: formatCurrency(summary.totalPurchaseOrder),
              icon: Icons.payment_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),

      _buildChartToggleButtons(),
      const SizedBox(height: 16),

      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedChart == 0
            ? _buildBarChartWithHint('top5revenue', topRevenueData, 'Top 5 Revenue')
            : _buildBarChartWithHint('top5expense', topExpenseData, 'Top 5 Expense'),
      ),
      const SizedBox(height: 24),

      _buildTopTable('Top 5 Revenue', data.topRevenue, _themeColor),
      const SizedBox(height: 24),
      _buildTopTable('Top 5 Expense', data.topExpense, Colors.red),
      const SizedBox(height: 24),

      _buildRatioCard(),
      const SizedBox(height: 24),

      AccountingAgingCard(
        title: 'Aging Piutang (Receivables)',
        items: data.agingPiutang,
        isReceivable: true,
      ),
      const SizedBox(height: 24),

      AccountingAgingCard(
        title: 'Aging Utang (Payables)',
        items: data.agingUtang,
        isReceivable: false,
      ),
      const SizedBox(height: 32),
    ];
  }

  List<KpiRow> _kpiRows(KpiData kpi, KpiPeriods p, {bool isPercent = false}) {
    String fmt(KpiMetric m) => isPercent
        ? '${m.realisasi.toStringAsFixed(0)}% / ${m.plan.toStringAsFixed(0)}%'
        : '${formatCurrency(m.realisasi)} / ${formatCurrency(m.plan)}';

    KpiRow row(String label, KpiMetric m) => KpiRow(
          label: label,
          value: fmt(m),
          achievement: '${m.achievement.toStringAsFixed(0)}%',
        );

    return [
      row(kpi.labelThisMonth, p.thisMonth),
      row(kpi.labelYtd, p.ytd),
      row(kpi.labelFullPeriod, p.fullPeriod),
    ];
  }

  String _yearLabel(FilterInfo f) {
    final sy = f.startDate.length >= 4 ? f.startDate.substring(0, 4) : '';
    final ey = f.endDate.length >= 4 ? f.endDate.substring(0, 4) : '';
    return sy == ey ? ey : '$sy - $ey';
  }

  List<Widget> _buildChartView(AccountingDashboardResponse data) {
    final kpi = data.kpi;

    final categoryData = data.customerCategory
        .map((c) => AccountingChartData(label: c.name, value: c.totalSales, color: _themeColor))
        .toList();

    return [
      AccountingKpiCard(
        title: 'Laba (Rugi)',
        subtitle: 'Realisasi vs Planned SO-PO',
        color: const Color(0xFF0A2540),
        rows: _kpiRows(kpi, kpi.profit),
      ),
      const SizedBox(height: 12),
      AccountingKpiCard(
        title: 'Pendapatan',
        subtitle: 'Realisasi vs Sales Order',
        color: const Color(0xFF0B8736),
        rows: _kpiRows(kpi, kpi.revenue),
      ),
      const SizedBox(height: 12),
      AccountingKpiCard(
        title: 'Biaya/Pendapatan',
        subtitle: 'Realisasi vs PO/SO',
        color: const Color(0xFFE0A800),
        rows: _kpiRows(kpi, kpi.biayaRatio, isPercent: true),
      ),
      const SizedBox(height: 12),
      AccountingKpiCard(
        title: 'Piutang (Receivable)',
        color: const Color(0xFFB41C1C),
        rows: [
          KpiRow(label: 'Outstanding', value: formatCurrency(kpi.receivableOutstanding)),
          KpiRow(
            label: 'Collection Rate (${kpi.labelYtd})',
            achievement: '${kpi.collectionRate.toStringAsFixed(0)}%',
          ),
        ],
      ),
      const SizedBox(height: 24),

      AccountingFinancialChart(
        title: 'Financial Performance ${_yearLabel(data.filter)}',
        data: data.charts.financialPerformance,
      ),
      const SizedBox(height: 24),

      AccountingBarChart(data: categoryData, title: 'Sales by Customer Category'),
      const SizedBox(height: 24),

      AccountingTopCustomerCard(title: 'Top 20 Customer by Sales', items: data.topCustomers),
      const SizedBox(height: 32),
    ];
  }
}