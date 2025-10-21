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
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/personalized_header.dart';

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

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchData();
  }

  Future<DashboardData> _fetchData() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';
    final rawData = await _repository.fetchDashboardData(token);
    return DashboardData.fromJson(rawData);
  }

  void _showDetailDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Detail information for $title.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<ChartData> _processPieData(List<ChartData> originalData, {double thresholdPercent = 3.0}) {
    if (originalData.isEmpty) return [];

    // Hitung total nilai untuk mendapatkan persentase
    final double totalValue = originalData.fold(0, (sum, item) => sum + item.value);
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

    // Jika ada slice kecil, gabungkan menjadi "Lainnya"
    if (otherSlices.isNotEmpty) {
      final double otherValue = otherSlices.fold(0, (sum, item) => sum + item.value);
      mainSlices.add(
        ChartData(
          label: 'Lainnya',
          value: otherValue,
          color: Colors.grey.shade400, // Warna khusus untuk "Lainnya"
        ),
      );
    }

    // Urutkan dari terbesar ke terkecil agar tampilan lebih rapi
    mainSlices.sort((a, b) => b.value.compareTo(a.value));

    return mainSlices;
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna aksen utama
    const Color accentColor = Color(0xFF2D6A4F);

    // Warna Khaki untuk Shadow
    const Color khakiShadow = Color(0xFFF0E68C);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.modul);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: accentColor,
              border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
              boxShadow: [
                BoxShadow(
                  // Menggunakan warna Khaki dengan sedikit transparansi untuk kelembutan
                  color: khakiShadow.withOpacity(0.4),
                  blurRadius: 2, // Blur yang cukup besar
                  spreadRadius: 2,
                  offset: const Offset(0, 2), // Shadow di bawah
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  'Inventory',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),


      drawerScrimColor: Colors.black.withOpacity(0.25), // Opasitas lebih rendah
      drawer: BackdropFilter(
        // Sigma yang lebih kecil untuk blur yang lebih halus
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
          final processedWarehouseData = _processPieData(dashboardData.charts.stockByWarehouse);
          final processedLocationData = _processPieData(dashboardData.charts.stockByLocation);

          return SingleChildScrollView(
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
                        onTap: () => _showDetailDialog(context, 'Receipt Note'),
                      ),
                      StatCard(
                        title: "Delivery Note",
                        value: dashboardData.summary.deliveryNote,
                        onTap: () =>
                            _showDetailDialog(context, 'Delivery Note'),
                      ),
                      StatCard(
                        title: "Internal Transfer",
                        value: dashboardData.summary.internalTransfer,
                        onTap: () =>
                            _showDetailDialog(context, 'Internal Transfer'),
                      ),
                      StatCard(
                        title: "Stock count",
                        value: dashboardData.summary.stockCount,
                        onTap: () => _showDetailDialog(context, 'Stock count'),
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
                          titleStyle: GoogleFonts.poppins(
                            fontSize: 11,
                          ),
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
                  _buildSectionTitle("Stock"),
                  const SizedBox(height: 16),
                  _buildStockToggleButtons(),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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
                  _buildLegend(
                    _selectedStockView == 0
                        ? processedWarehouseData
                        : processedLocationData,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Top 5 Hand Stock"),
                  const SizedBox(height: 8),
                  TopProductList(topProducts: dashboardData.topProducts),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Product Category"),
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

                  _buildSectionTitle("Stock Moves"),
                  const SizedBox(height: 4), // Spasi setelah judul
                  Text( // Teks petunjuk baru
                    "Tap a bar for more details",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12), // Spasi sebelum tombol
                  _buildStockMovesToggleButtons(), // Tombol dengan gaya baru
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStockToggleButtons() {
    // Definisi warna agar mudah diubah
    const Color selectedColor = Color(0xFF2D6A4F); // Warna hijau tua yang solid
    const Color unselectedColor = Colors.white;
    const Color selectedTextColor = Colors.white;
    const Color unselectedTextColor = Colors.black54;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Tombol "By Warehouse"
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStockView = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedStockView == 0 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedStockView == 0
                      ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  "By Warehouse",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedStockView == 0 ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          // Tombol "Per Location"
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStockView = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedStockView == 1 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedStockView == 1
                      ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  "By Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedStockView == 1 ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMovesToggleButtons() {
    const Color selectedColor = Color(0xFF2D6A4F); // Warna biru sebagai pembeda
    const Color unselectedColor = Colors.white;
    const Color selectedTextColor = Colors.white;
    const Color unselectedTextColor = Colors.black54;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Tombol "By Product"
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStockMovesView = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedStockMovesView == 0 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedStockMovesView == 0
                      ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  "By Product",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedStockMovesView == 0 ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          // Tombol "By Location"
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStockMovesView = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedStockMovesView == 1 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedStockMovesView == 1
                      ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  "By Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedStockMovesView == 1 ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<ChartData> data) {
    final double totalValue = data.fold(
      0,
          (previousValue, element) => previousValue + element.value,
    );

    if (data.isEmpty || totalValue == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: data.map((d) {
            final percentage = (d.value / totalValue) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: d.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(d.label, style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}