import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; 

import '../repositories/inventory_repository.dart';
import '../models/dashboard_data_model.dart';

import '../models/chart_data_model.dart';
import '../widget/bar_chart_widget.dart';
import '../widget/pie_chart_widget.dart';
import '../widget/stat_card_widget.dart';
import '../widget/inventory_drawer_widget.dart';
import '../widget/top_product_widget.dart';
import '../widget/dashboard_skeleton_widget.dart';
import '../../../../shared/widgets/personalized_header.dart';

// [BARU] Impor file widget yang sudah dipecah
import '../widget/inventory_widgets.dart';

class DashboardInventoryScreen extends StatefulWidget {
  const DashboardInventoryScreen({super.key});

  @override
  State<DashboardInventoryScreen> createState() =>
      _DashboardInventoryScreenState();
}

class _DashboardInventoryScreenState extends State<DashboardInventoryScreen> {
  int _selectedStockView = 0;
  int _selectedStockMovesView = 0;

  final InventoryRepository _repository = InventoryRepository();
  late Future<DashboardData> _dashboardFuture;
  late ScrollController _scrollController;

  // --- ANIMASI ---
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
  // --- END ANIMASI ---

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchData();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<DashboardData> _fetchData() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';
    final rawData = await _repository.fetchDashboardData(token);
    return DashboardData.fromJson(rawData);
  }

  List<ChartData> _processPieData(
    List<ChartData> originalData, {
    double thresholdPercent = 3.0,
  }) {
    // ... (Fungsi ini adalah logika data, jadi Boleh tetap di sini)
    if (originalData.isEmpty) return [];
    final double totalValue = originalData.fold(
      0,
      (sum, item) => sum + item.value,
    );
    if (totalValue == 0) return [];
    List<ChartData> mainSlices = [];
    List<ChartData> otherSlices = [];
    for (var item in originalData) {
      final percentage = (item.value / totalValue) * 100;
      if (percentage < thresholdPercent) {
        otherSlices.add(item);
      } else {
        mainSlices.add(item);
      }
    }
    if (otherSlices.isNotEmpty) {
      final double otherValue = otherSlices.fold(
        0,
        (sum, item) => sum + item.value,
      );
      mainSlices.add(
        ChartData(
          label: 'Lainnya',
          value: otherValue,
          color: Colors.grey.shade400,
        ),
      );
    }
    mainSlices.sort((a, b) => b.value.compareTo(a.value));
    return mainSlices;
  }

  // [BARU] Helper widget untuk animasi transisi "pop" (fade + scale)
  Widget _buildTransition(Widget child, Animation<double> animation) {
    final scaleAnimation = Tween<double>(
      begin: 0.9, 
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation, 
      curve: Curves.easeOutCubic,
    ));
    
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.5, 1.0), // Mulai fade in di pertengahan scale
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // --- Bagian AppBar (leading, title, actions) tidak berubah ---
        leading: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double progress = 0.0;
            if (_scrollController.hasClients && _scrollController.offset > 0) {
              progress = (_scrollController.offset / _scrollThreshold).clamp(
                0.0,
                1.0,
              );
            }
            final double currentIconSize = lerpDouble(
              _initialIconSize,
              _scrolledIconSize,
              progress,
            )!;
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: currentIconSize,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double progress = 0.0;
            if (_scrollController.hasClients && _scrollController.offset > 0) {
              progress = (_scrollController.offset / _scrollThreshold).clamp(
                0.0,
                1.0,
              );
            }
            final Alignment currentAlignment = Alignment.lerp(
              _initialTitleAlignment,
              _scrolledTitleAlignment,
              progress,
            )!;
            final TextStyle currentTitleStyle = TextStyle.lerp(
              _initialTitleStyle,
              _scrolledTitleStyle,
              progress,
            )!;
            return Container(
              width: double.infinity,
              child: Align(
                alignment: currentAlignment,
                child: Text(
                  'Dashboard Inventory',
                  style: currentTitleStyle,
                ),
              ),
            );
          },
        ),
        actions: [
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double progress = 0.0;
              if (_scrollController.hasClients &&
                  _scrollController.offset > 0) {
                progress = (_scrollController.offset / _scrollThreshold).clamp(
                  0.0,
                  1.0,
                );
              }
              final double currentIconSize = lerpDouble(
                _initialIconSize,
                _scrolledIconSize,
                progress,
              )!;
              return IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.black,
                  size: currentIconSize,
                ),
                onPressed: () {
                  // TODO: Tambahkan navigasi ke halaman profil
                  print('Profile icon tapped');
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      drawerScrimColor: Colors.black.withOpacity(0.25),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: const DashboardDrawer(),
      ),
      // =========================================================
      body: FutureBuilder<DashboardData>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DashboardSkeleton();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final dashboardData = snapshot.data!;
          final processedWarehouseData = _processPieData(
            dashboardData.charts.stockByWarehouse,
          );
          final processedLocationData = _processPieData(
            dashboardData.charts.stockByLocation,
          );

          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PersonalizedHeader(),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        title: "Receipt Note",
                        value: dashboardData.summary.receiptNote,
                      ),
                      StatCard(
                        title: "Delivery Note",
                        value: dashboardData.summary.deliveryNote,
                      ),
                      StatCard(
                        title: "Internal Transfer",
                        value: dashboardData.summary.internalTransfer,
                      ),
                      StatCard(
                        title: "Stock count",
                        value: dashboardData.summary.stockCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        StatCard(
                          title: "Product",
                          value: dashboardData.summary.productTotal,
                          width: 150,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "On Hand Stock",
                          value: dashboardData.summary.onHandStock,
                          valueColor: const Color(0xFF2D6A4F),
                          width: 150,
                          titleStyle: GoogleFonts.poppins(fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "Low Stock Alert",
                          value: dashboardData.summary.lowStockAlert,
                          valueColor: Colors.orange,
                          width: 150,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "Expiring Soon",
                          value: dashboardData.summary.expiringSoon,
                          valueColor: Colors.red,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // [DIUBAH] Menggunakan Widget baru
                  const SectionTitle(title: "Stock"),
                  const SizedBox(height: 16),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  StockToggleButtons(
                    selectedIndex: _selectedStockView,
                    onTap: (index) {
                      setState(() => _selectedStockView = index);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    
                    // [PERUBAHAN TERBARU] Menggunakan helper animasi
                    transitionBuilder: _buildTransition,

                    child: _selectedStockView == 0
                        ? StockPieChart(
                            key: const ValueKey('warehouse'),
                            data: processedWarehouseData,
                            title: "Stok By warehouse",
                          )
                        : StockPieChart(
                            key: const ValueKey('location'),
                            data: processedLocationData,
                            title: "Stok By location",
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap on a slice to view details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  StockLegend(
                    data: _selectedStockView == 0
                        ? processedWarehouseData
                        : processedLocationData,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  const SectionTitle(title: "Top 5 Hand Stock"),
                  const SizedBox(height: 8),
                  TopProductList(topProducts: dashboardData.topProducts),
                  const SizedBox(height: 24),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  const SectionTitle(title: "Product Category"),
                  const SizedBox(height: 4),
                  Text(
                    "Tap a bar for more details",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProductBarChart(
                    data: dashboardData.charts.productsByCategory,
                  ),
                  const SizedBox(height: 24),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  const SectionTitle(title: "Stock Moves"),
                  const SizedBox(height: 4),
                  Text(
                    "Tap a bar for more details",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // [DIUBAH] Menggunakan Widget baru
                  StockMovesToggleButtons(
                    selectedIndex: _selectedStockMovesView,
                    onTap: (index) {
                      setState(() => _selectedStockMovesView = index);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),

                    // [PERUBAHAN TERBARU] Menggunakan helper animasi yang sama
                    transitionBuilder: _buildTransition,

                    child: _selectedStockMovesView == 0
                        ? ProductBarChart(
                            key: const ValueKey('moves_product'),
                            data: dashboardData.charts.stockMovesByProduct,
                            barColor: Colors.green,
                          )
                        : ProductBarChart(
                            key: const ValueKey('moves_location'),
                            data: dashboardData.charts.stockMovesByLocation,
                            barColor: const Color.fromARGB(255, 74, 227, 214),
                          ),
                  ),
                  const SizedBox(height: 24), // [FIX] Tambahan spasi di akhir
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}