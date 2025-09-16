import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/inventory_repository.dart';
import '../models/dashboard_data_model.dart';

import '../models/chart_data_model.dart';
import '../widget/bar_chart_widget.dart';
import '../widget/pie_chart_widget.dart';
import '../widget/stat_card_widget.dart';
import '../widget/inventory_drawer_widget.dart';
import '../widget/top_product_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.modul);
          },
          child: Text(
            'Inventory',
            style: GoogleFonts.montserrat(
              color: const Color(0xFF2D6A4F),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 4,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const DashboardDrawer(),
      body: FutureBuilder<DashboardData>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final dashboardData = snapshot.data!;

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
                    // --- PERUBAHAN DI SINI ---
                    // Kembalikan ke nilai yang lebih seimbang, misal 0.9
                    // Karena StatCard sekarang sudah bisa menangani ukurannya sendiri.
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
                    height: 120,
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
                          valueColor: Colors.teal,
                          width: 150,
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
                      data: dashboardData.charts.stockByWarehouse,
                      title: "Stok per Gudang",
                    )
                        : StockPieChart(
                      key: const ValueKey('location'),
                      data: dashboardData.charts.stockByLocation,
                      title: "Stok per Lokasi",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegend(
                    _selectedStockView == 0
                        ? dashboardData.charts.stockByWarehouse
                        : dashboardData.charts.stockByLocation,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Top 5 Hand Stock"),
                  const SizedBox(height: 8),
                  TopProductList(topProducts: dashboardData.topProducts),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Product Category"),
                  const SizedBox(height: 16),
                  ProductBarChart(
                    data: dashboardData.charts.productsByCategory,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Stock Moves"),
                  const SizedBox(height: 16),
                  _buildStockMovesToggleButtons(),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return ToggleButtons(
          isSelected: [_selectedStockView == 0, _selectedStockView == 1],
          onPressed: (index) {
            setState(() {
              _selectedStockView = index;
            });
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: Colors.teal,
          color: Colors.teal,
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 2 - 2,
            height: 40,
          ),
          children: const [Text("By Warehouse"), Text("Per Location")],
        );
      },
    );
  }

  Widget _buildStockMovesToggleButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ToggleButtons(
          isSelected: [
            _selectedStockMovesView == 0,
            _selectedStockMovesView == 1,
          ],
          onPressed: (index) {
            setState(() {
              _selectedStockMovesView = index;
            });
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: const Color.fromARGB(255, 101, 196, 126),
          color: const Color.fromARGB(255, 32, 157, 49),
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 2 - 2,
            height: 40,
          ),
          children: const [Text("By Product"), Text("By Location")],
        );
      },
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