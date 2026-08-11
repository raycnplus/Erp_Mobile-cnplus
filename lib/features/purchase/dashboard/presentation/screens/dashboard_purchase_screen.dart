import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/models/purchase_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/controllers/purchase_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/widgets/purchase_dashboard_shimmer.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/widgets/purchase_analysis_chart.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/widgets/top_list_card.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/widgets/purchase_bar_chart_widget.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';    
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';

class DashboardPurchaseScreen extends StatefulWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  State<DashboardPurchaseScreen> createState() => _DashboardPurchaseScreenState();
}

class _DashboardPurchaseScreenState extends State<DashboardPurchaseScreen> {
  int _selectedChart = 0;

  late PurchaseDashboardController _controller;
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

  static const Color _themeColor = Color(0xFF029379);
  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _controller       = getIt<PurchaseDashboardController>();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PurchaseDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.purchase),
        ),
        body: Consumer<PurchaseDashboardController>(
          builder: (context, controller, _) {
            if (controller.status == PurchaseDashboardStatus.error) {
              return _buildErrorState(controller);
            }
            if (controller.status == PurchaseDashboardStatus.loading) {
              return const PurchaseDashboardShimmer();
            }
            if (controller.status == PurchaseDashboardStatus.loaded && controller.hasData) {
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
              child: Text('Dashboard Purchase',
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

  Widget _buildErrorState(PurchaseDashboardController controller) {
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

  Widget _buildDateFilter(PurchaseDashboardController controller) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(child: _buildToggleButton('Top 5 Product', 0)),
            const SizedBox(width: 10), 
            Expanded(child: _buildToggleButton('Top 5 Vendor', 1)),
          ],
        );
      },
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

  List<PurchaseChartData> _transformToProductChartData(List<TopProduct> products) =>
      products.map((p) => PurchaseChartData(
            label: p.productName,
            value: p.totalSpent,
            color: Colors.pinkAccent,
          )).toList();

  List<PurchaseChartData> _transformToVendorChartData(List<TopVendor> vendors) =>
      vendors.map((v) => PurchaseChartData(
            label: v.vendorName,
            value: v.totalSpent,
            color: Colors.cyan,
          )).toList();

  List<MonthlyPurchaseData> _transformToAnalysisData(SpendingByMonth spending) {
    final List<MonthlyPurchaseData> chartData = [];
    for (int i = 0; i < spending.labels.length; i++) {
      final parts = spending.labels[i].split('-');
      final month = int.tryParse(parts[0]) ?? (i + 1);
      final year  = parts.length > 1 ? int.tryParse(parts[1]) ?? DateTime.now().year : DateTime.now().year; // ✅ ambil dari label
      chartData.add(MonthlyPurchaseData(month: month, year: year, amount: spending.data[i]));
    }
    return chartData;
  }

  List<TopListData> _transformToCategoryList(List<TopCategory> categories) =>
      categories.map((c) => TopListData(
            title: c.productCategoryName,
            value: formatCurrency(c.totalAmount),
          )).toList();

  List<TopListData> _transformToPurchaseOrderList(List<TopPurchaseOrder> orders) =>
      orders.map((o) => TopListData(
            title: o.reference,
            value: formatCurrency(o.totalAmount),
          )).toList();

  Widget _buildDashboardContent(PurchaseDashboardController controller) {
    final data                = controller.dashboardData!;
    final summary             = data.summary;
    final top5ProductData     = _transformToProductChartData(data.topProducts);
    final top5VendorData      = _transformToVendorChartData(data.topVendors);
    final purchaseAnalysisData = _transformToAnalysisData(data.charts.spendingByMonth);
    final topCategoryData     = _transformToCategoryList(data.topCategories);
    final topPurchaseOrderData = _transformToPurchaseOrderList(data.topPurchaseOrders);

    return RefreshIndicator(
      onRefresh: controller.refresh,
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

            Row(
              children: [
                Expanded(child: StatCard(title: "Purchase Request", value: summary.purchaseRequest.toString(), icon: Icons.request_page_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: "RFQ",              value: summary.rfq.toString(),             icon: Icons.description_outlined)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(title: "Purchase Order",  value: summary.purchaseOrder.toString(),  icon: Icons.shopping_bag_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: "Direct Purchase", value: summary.directPurchase.toString(), icon: Icons.shopping_cart_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            _buildChartToggleButtons(),
            const SizedBox(height: 16),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedChart == 0
                  ? Column(
                      key: const ValueKey('top5product'),
                      children: [
                        PurchaseBarChart(data: top5ProductData, title: "Top 5 Product"),
                        const SizedBox(height: 8),
                        Text("Tap a bar for more details",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic)),
                      ],
                    )
                  : Column(
                      key: const ValueKey('top5vendor'),
                      children: [
                        PurchaseBarChart(data: top5VendorData, title: "Top 5 Vendor"),
                        const SizedBox(height: 8),
                        Text("Tap a bar for more details",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
            ),
            const SizedBox(height: 24),

            // Purchase Analysis Line Chart
            PurchaseAnalysisChart(purchaseData: purchaseAnalysisData),
            const SizedBox(height: 24),

            // Top lists
            TopListCard(title: 'Top 5 Purchase Order', items: topPurchaseOrderData),
            const SizedBox(height: 24),
            TopListCard(title: 'Top 5 Category Product', items: topCategoryData),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}