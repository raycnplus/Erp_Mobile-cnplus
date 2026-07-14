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
  int _selectedChart = 0; // 0 = Top 5 Revenue, 1 = Top 5 Expense

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

  Widget _buildChartToggleButtons() {
    return Row(
      children: [
        Expanded(child: _buildToggleButton('Top 5 Revenue', 0)),
        const SizedBox(width: 10),
        Expanded(child: _buildToggleButton('Top 5 Expense', 1)),
      ],
    );
  }

  Widget _buildToggleButton(String label, int index) {
    final isSelected = _selectedChart == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChart = index),
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

  List<AccountingChartData> _transformToChartData(List<TopListData> items, Color? color) {
    return items.map((item) => AccountingChartData(
      label: item.title,
      value: _parseAmount(item.value),
      color: color,
    )).toList();
  }

  double _parseAmount(String value) {
    final cleaned = value.replaceAll('Rp', '').replaceAll('.', '').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  Widget _buildTopRevenueTable(List<TopListData> items) {
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
              'Top 5 Revenue',
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
                  child: Text(
                    'No data available',
                    style: GoogleFonts.poppins(color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => _themeColor.withOpacity(0.05),
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
                            item.value,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _themeColor,
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

  Widget _buildTopExpenseTable(List<TopListData> items) {
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
              'Top 5 Expense',
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
                  child: Text(
                    'No data available',
                    style: GoogleFonts.poppins(color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.red.withOpacity(0.05),
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
                            item.value,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
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

  Widget _buildDashboardContent(AccountingDashboardController controller) {
    final data = controller.dashboardData!;
    final summary = data.summary;

    // Hitung ratio
    final double roa = summary.totalInvoice > 0 
        ? (summary.totalInvoice / 1000000000) * 100
        : 56.0;
    final double roi = summary.totalSalesOrder > 0 
        ? (summary.totalSalesOrder / 1000000000) * 100
        : 70.0;
    final double roe = (summary.totalInvoice - summary.totalBill) > 0 
        ? ((summary.totalInvoice - summary.totalBill) / 1000000000) * 100
        : 64.0;

    final topRevenueData = _transformToChartData(data.topRevenue, _themeColor);
    final topExpenseData = _transformToChartData(data.topExpense, Colors.red);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: _themeColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 16),

            _buildDateFilter(controller),
            const SizedBox(height: 16),

            // 4 STAT CARDS: Current Income, Receivables, Current Expense, Payables
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
                    value: formatCurrency(summary.totalInvoice),
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
                    value: formatCurrency(summary.totalBill),
                    icon: Icons.payment_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // TOGGLE BUTTONS (Top 5 Revenue / Top 5 Expense)
            _buildChartToggleButtons(),
            const SizedBox(height: 16),

            // BAR CHART (sesuai toggle)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedChart == 0
                  ? Column(
                      key: const ValueKey('top5revenue'),
                      children: [
                        AccountingBarChart(
                          data: topRevenueData,
                          title: "Top 5 Revenue",
                        ),
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
                    )
                  : Column(
                      key: const ValueKey('top5expense'),
                      children: [
                        AccountingBarChart(
                          data: topExpenseData,
                          title: "Top 5 Expense",
                        ),
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
                    ),
            ),
            const SizedBox(height: 24),

            // TABLES: Top 5 Revenue & Top 5 Expense
            _buildTopRevenueTable(data.topRevenue),
            const SizedBox(height: 24),
            _buildTopExpenseTable(data.topExpense),
            const SizedBox(height: 24),

            // RATIO CARD
            Card(
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
                          child: Icon(Icons.pie_chart_outline, color: Colors.orange, size: 24),
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
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('ROA', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(
                                '${roa.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _themeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('ROI', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(
                                '${roi.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _themeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('ROE', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(
                                '${roe.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _themeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // AGING PIUTANG & AGING UTANG
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
          ],
        ),
      ),
    );
  }
}