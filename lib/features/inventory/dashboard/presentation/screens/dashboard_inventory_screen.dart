import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/controllers/inventory_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/widgets/bar_chart_widget.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/widgets/dashboard_skeleton_widget.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/widgets/inventory_widgets.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/widgets/pie_chart_widget.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/widgets/top_product_widget.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';

class DashboardInventoryScreen extends StatefulWidget {
  const DashboardInventoryScreen({super.key});

  @override
  State<DashboardInventoryScreen> createState() =>
      _DashboardInventoryScreenState();
}

class _DashboardInventoryScreenState extends State<DashboardInventoryScreen> {
  int _selectedStockView = 0;
  int _selectedStockMovesView = 0;

  final PageController _pageController = PageController();
  int _currentCarouselPage = 0;

  late InventoryDashboardController _controller;
  late ScrollController _scrollController;

  static const Color _theme = Color(0xFF2D6A4F);
  final _dateFmt = DateFormat('dd MMM yyyy');

  final Alignment _initialTitleAlignment = const Alignment(-0.6, 0.0);
  final Alignment _scrolledTitleAlignment = const Alignment(-1.20, 0.0);
  final TextStyle _initialTitleStyle = GoogleFonts.poppins(
    color: Colors.black87,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  final TextStyle _scrolledTitleStyle = GoogleFonts.poppins(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  final double _initialIconSize = 28.0;
  final double _scrolledIconSize = 24.0;
  final double _scrollThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    _controller = getIt<InventoryDashboardController>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.loadDashboard(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
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
          colorScheme: const ColorScheme.light(primary: _theme),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _controller.updateDateRange(picked.start, picked.end);
    }
  }

  List<ChartItem> _processPieData(
    List<ChartItem> originalData, {
    double thresholdPercent = 3.0,
  }) {
    if (originalData.isEmpty) return [];
    final total =
        originalData.fold<double>(0, (sum, item) => sum + item.value);
    if (total == 0) return [];

    final List<ChartItem> main = [];
    final List<ChartItem> other = [];

    for (final item in originalData) {
      if ((item.value / total) * 100 < thresholdPercent) {
        other.add(item);
      } else {
        main.add(item);
      }
    }

    if (other.isNotEmpty) {
      final otherTotal =
          other.fold<double>(0, (sum, item) => sum + item.value);
      main.add(ChartItem(
        label: 'Lainnya',
        value: otherTotal,
        color: Colors.grey.shade400,
      ));
    }

    main.sort((a, b) => b.value.compareTo(a.value));
    return main;
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.5, 1.0),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InventoryDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.inventory),
        ),
        body: Consumer<InventoryDashboardController>(
          builder: (context, controller, _) {
            if (controller.status == DashboardStatus.error) {
              return _buildErrorState(controller);
            }
            if (controller.status == DashboardStatus.loading) {
              return const DashboardSkeleton();
            }
            if (controller.status == DashboardStatus.loaded &&
                controller.hasData) {
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
          final p = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: lerpDouble(_initialIconSize, _scrolledIconSize, p),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final p = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.lerp(
                _initialTitleAlignment,
                _scrolledTitleAlignment,
                p,
              )!,
              child: Text(
                'Dashboard Inventory',
                style: TextStyle.lerp(
                  _initialTitleStyle,
                  _scrolledTitleStyle,
                  p,
                )!,
              ),
            ),
          );
        },
      ),
      actions: [
        AnimatedBuilder(
          animation: _scrollController,
          builder: (context, _) {
            final p = _scrollController.hasClients
                ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
                : 0.0;
            return IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
                size: lerpDouble(_initialIconSize, _scrolledIconSize, p),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildErrorState(InventoryDashboardController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage ?? 'An error occurred',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.loadDashboard,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(InventoryDashboardController ctrl) {
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: _theme,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFmt.format(ctrl.startDate)}  →  ${_dateFmt.format(ctrl.endDate)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _theme,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCarousel(InventoryDashboardData data) {
    final pages = [
      [
        StatCard(
          title: 'Receipt Note',
          value: data.summary.receiptNote,
          icon: Icons.description_outlined,
        ),
        StatCard(
          title: 'Delivery Note',
          value: data.summary.deliveryNote,
          icon: Icons.local_shipping_outlined,
        ),
        StatCard(
          title: 'Internal Transfer',
          value: data.summary.internalTransfer,
          icon: Icons.swap_horiz_outlined,
        ),
        StatCard(
          title: 'Stock Count',
          value: data.summary.stockCount,
          icon: Icons.fact_check_outlined,
        ),
      ],
      [
        StatCard(
          title: 'Product',
          value: data.summary.productTotal,
          icon: Icons.inventory_2_outlined,
        ),
        StatCard(
          title: 'On Hand Stock',
          value: data.summary.onHandStock,
          valueColor: _theme,
          icon: Icons.warehouse_outlined,
        ),
        StatCard(
          title: 'Low Stock Alert',
          value: data.summary.lowStockAlert,
          valueColor: Colors.orange,
          icon: Icons.warning_amber_outlined,
        ),
        StatCard(
          title: 'Expiring Soon',
          value: data.summary.expiringSoon,
          valueColor: Colors.red,
          icon: Icons.timer_outlined,
        ),
      ],
    ];

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _currentCarouselPage = i),
            itemBuilder: (_, pageIndex) {
              final cards = pages[pageIndex];
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 10),
                      Expanded(child: cards[1]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      const SizedBox(width: 10),
                      Expanded(child: cards[3]),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (i) {
            final isActive = i == _currentCarouselPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? _theme : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDashboardContent(InventoryDashboardController controller) {
    final data = controller.dashboardData!;
    final processedWarehouseData =
        _processPieData(data.charts.stockByWarehouse);
    final processedLocationData =
        _processPieData(data.charts.stockByLocation);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PersonalizedHeader(),
              const SizedBox(height: 16),
              _buildDateFilter(controller),
              const SizedBox(height: 16),
              _buildStatCarousel(data),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Stock'),
              const SizedBox(height: 16),
              StockToggleButtons(
                selectedIndex: _selectedStockView,
                onTap: (i) => setState(() => _selectedStockView = i),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: _buildTransition,
                child: _selectedStockView == 0
                    ? StockPieChart(
                        key: const ValueKey('warehouse'),
                        data: processedWarehouseData,
                        title: 'Stok By Warehouse',
                      )
                    : StockPieChart(
                        key: const ValueKey('location'),
                        data: processedLocationData,
                        title: 'Stok By Location',
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap on a slice to view details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              StockLegend(
                data: _selectedStockView == 0
                    ? processedWarehouseData
                    : processedLocationData,
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Top 5 Hand Stock'),
              const SizedBox(height: 8),
              TopProductList(topProducts: data.topProducts),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Product Category'),
              const SizedBox(height: 4),
              Text(
                'Tap a bar for more details',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              ProductBarChart(data: data.charts.productsByCategory),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Stock Moves'),
              const SizedBox(height: 4),
              Text(
                'Tap a bar for more details',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              StockMovesToggleButtons(
                selectedIndex: _selectedStockMovesView,
                onTap: (i) => setState(() => _selectedStockMovesView = i),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: _buildTransition,
                child: _selectedStockMovesView == 0
                    ? ProductBarChart(
                        key: const ValueKey('moves_product'),
                        data: data.charts.stockMovesByProduct,
                        barColor: Colors.green,
                      )
                    : ProductBarChart(
                        key: const ValueKey('moves_location'),
                        data: data.charts.stockMovesByLocation,
                        barColor: const Color.fromARGB(255, 74, 227, 214),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}