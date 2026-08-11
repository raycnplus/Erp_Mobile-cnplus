import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/models/sales_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/controllers/sales_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/widgets/sales_chart_toggle_section.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/widgets/sales_analysis_chart.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/widgets/top_list_card.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';

class DashboardSalesScreen extends StatefulWidget {
  const DashboardSalesScreen({super.key});

  @override
  State<DashboardSalesScreen> createState() => _DashboardSalesScreenState();
}

class _DashboardSalesScreenState extends State<DashboardSalesScreen> {
  late SalesDashboardController _controller;
  late ScrollController _scrollController;

  final Alignment _initialTitleAlignment  = const Alignment(-0.6, 0.0);
  final Alignment _scrolledTitleAlignment = const Alignment(-1.20, 0.0);
  final TextStyle _initialTitleStyle = GoogleFonts.poppins(
    color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600,
  );
  final TextStyle _scrolledTitleStyle = GoogleFonts.poppins(
    color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600,
  );
  final double _initialIconSize  = 28.0;
  final double _scrolledIconSize = 24.0;
  final double _scrollThreshold  = 50.0;

  static const Color _themeColor = Color(0xFF409c9c);
  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _controller       = getIt<SalesDashboardController>();
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
      lastDate:  DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _controller.startDate,
        end:   _controller.endDate,
      ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _themeColor),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _controller.loadDashboard(start: picked.start, end: picked.end);
    }
  }
  
  List<MonthlySalesData> _transformToMonthlySalesData(List<SalesPerDate> items) {
    if (items.isEmpty) return [];

    final Map<String, MonthlySalesData> grouped = {};

    for (final item in items) {
      final parsedDate = _parseDate(item.date);
      if (parsedDate == null) continue;

      final key = '${parsedDate.month}-${parsedDate.year}';
      final existing = grouped[key];
      if (existing == null) {
        grouped[key] = MonthlySalesData(
          month: parsedDate.month,
          year: parsedDate.year,
          amount: item.totalAmount.toDouble(),
        );
      } else {
        grouped[key] = MonthlySalesData(
          month: existing.month,
          year: existing.year,
          amount: existing.amount + item.totalAmount.toDouble(),
        );
      }
    }

    final result = grouped.values.toList()
      ..sort((a, b) {
        final aDate = DateTime(a.year, a.month);
        final bDate = DateTime(b.year, b.month);
        return aDate.compareTo(bDate);
      });

    return result;
  }

  DateTime? _parseDate(String raw) {
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    try {
      return DateFormat('dd MMM yyyy').parse(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SalesDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.sales),
        ),
        body: Consumer<SalesDashboardController>(
          builder: (context, controller, _) {
            if (controller.status == SalesDashboardStatus.error) {
              return _buildErrorState(controller);
            }
            if (controller.status == SalesDashboardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.status == SalesDashboardStatus.loaded && controller.hasData) {
              return _buildContent(controller);
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
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
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
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.lerp(
                  _initialTitleAlignment, _scrolledTitleAlignment, progress)!,
              child: Text('Dashboard Sales',
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
                ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
                : 0.0;
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

  Widget _buildErrorState(SalesDashboardController controller) {
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
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SalesDashboardController controller) {
    final data = controller.dashboardData!;
    final monthlySalesData = _transformToMonthlySalesData(data.salesPerDate);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 16),

            _buildDateFilter(controller),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: StatCard(title: "Quotations",   value: data.quotation.toString(),   icon: Icons.description_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: "Sales Orders", value: data.salesOrder.toString(),  icon: Icons.receipt_long_outlined)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(title: "Direct Sales", value: data.directSales.toString(), icon: Icons.shopping_cart_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: "Invoices",     value: data.invoice.toString(),     icon: Icons.request_page_outlined)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(title: "Products", value: data.salesProductCount.toString(), icon: Icons.inventory_2_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: "Revenue",  value: formatCurrency(data.grandTotal),   icon: Icons.attach_money, valueColor: _themeColor)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(title: "Profit", value: formatCurrency(data.profit), icon: Icons.trending_up, valueColor: Colors.green)),
                const SizedBox(width: 10),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 24),

            SalesChartToggleSection(
              revenuePerDay: data.revenuePerDay,
              quantityPerDay: data.quantityPerDay,
              themeColor: _themeColor,
            ),
            const SizedBox(height: 24),

            _buildTopCustomersCard(data.topCustomers),
            const SizedBox(height: 24),

            _buildTopInvoicesCard(data.topInvoices),
            const SizedBox(height: 24),

            SalesAnalysisChart(
              salesData: monthlySalesData,
              mainColor: _themeColor,
            ),
            const SizedBox(height: 24),

            _buildSalesPerProductCard(data.salesPerProduct),
            const SizedBox(height: 24),

            _buildSalesPerCustomerCard(data.salesPerCustomer),
            const SizedBox(height: 24),

            _buildSalesPerSalespersonCard(data.salesPerSalesperson),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCustomersCard(List<TopCustomer> items) {
    return TopListCard(
      title: 'Top 5 Customers',
      mainColor: _themeColor,
      items: items
          .map((c) => TopListData(
                title: c.customerName,
                subtitle: c.categoryName.isEmpty ? null : c.categoryName,
                value: formatCurrency(c.totalAmount),
              ))
          .toList(),
    );
  }

  Widget _buildTopInvoicesCard(List<TopInvoice> items) {
    return TopListCard(
      title: 'Top 5 Invoices',
      mainColor: _themeColor,
      items: items
          .map((i) => TopListData(
                title: i.reference,
                subtitle: i.customerName,
                value: formatCurrency(i.grandTotal),
              ))
          .toList(),
    );
  }

  Widget _buildSalesPerProductCard(List<SalesPerProduct> items) {
    return TopListCard(
      title: 'Sales Per Product',
      mainColor: _themeColor,
      items: items
          .map((p) => TopListData(
                title: p.productName,
                subtitle: 'Qty: ${p.qtyTotal.toStringAsFixed(0)}',
                value: formatCurrency(p.totalAmount),
              ))
          .toList(),
    );
  }

  Widget _buildSalesPerCustomerCard(List<SalesPerCustomer> items) {
    return TopListCard(
      title: 'Sales Per Customer',
      mainColor: _themeColor,
      items: items
          .map((c) => TopListData(
                title: c.customerName,
                subtitle: '${c.orderCount} orders',
                value: formatCurrency(c.totalAmount),
              ))
          .toList(),
    );
  }

  Widget _buildSalesPerSalespersonCard(List<SalesPerSalesperson> items) {
    return TopListCard(
      title: 'Sales Per Salesperson',
      mainColor: _themeColor,
      items: items
          .map((s) => TopListData(
                title: s.salespersonName,
                subtitle: '${s.orderCount} orders',
                value: formatCurrency(s.totalAmount),
              ))
          .toList(),
    );
  }

  Widget _buildDateFilter(SalesDashboardController controller) {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: _themeColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFormat.format(controller.startDate)}  →  ${_dateFormat.format(controller.endDate)}',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _themeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Filter',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}