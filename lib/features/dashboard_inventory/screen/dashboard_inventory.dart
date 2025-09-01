import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/chart_data_model.dart';
import '../widget/bar_chart_widget.dart';
import '../widget/pie_chart_widget.dart';
import '../widget/stat_card_widget.dart';
import '../widget/dashboard_drawer_widget.dart';
import '../widget/top_product_widget.dart';
import '../../../core/routes/app_routes.dart';
import '../../../services/api_base.dart';

class DashboardInventoryScreen extends StatefulWidget {
  const DashboardInventoryScreen({super.key});

  @override
  State<DashboardInventoryScreen> createState() =>
      _DashboardInventoryScreenState();
}

class _DashboardInventoryScreenState extends State<DashboardInventoryScreen> {
  int _selectedStockView = 0;
  int _selectedStockMovesView = 0;
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = fetchDashboardData();
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';

    debugPrint('TOKEN: $token');

    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
    debugPrint('Headers: ${response.headers}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception(
        'Token tidak valid atau sudah expired. Silakan login ulang.',
      );
    } else {
      throw Exception('Failed to load dashboard data');
    }
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
          child: const Text(
            'Inventory',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const DashboardDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final data = snapshot.data!;
          final summary = data['summary'] ?? {};
          final charts = data['charts'] ?? {};
          final topProducts = data['top_products'] ?? [];

          // Parse chart data
          final productCategoryData = ChartData.fromChartMap(
            charts['products_by_category'],
            color: Colors.cyan,
          );
          final stockMovesByProductData = ChartData.fromChartMap(
            charts['stock_moves_by_product'],
            color: Colors.green,
          );
          final stockMovesByLocationData = ChartData.fromChartMap(
            charts['stock_moves_by_location'],
            color: Colors.amber,
          );
          final stockByWarehouseData = ChartData.fromChartMap(
            charts['stock_per_warehouse'],
            color: Colors.teal,
          );
          final stockByLocationData = ChartData.fromChartMap(
            charts['stock_per_location'],
            color: Colors.blue,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 16 * 2 - 8 * 3) / 4,
                        child: StatCard(
                          title: "Receipt Note",
                          value: summary['receipt_note']?.toString() ?? "0",
                          onTap: () => _showDetailDialog(context, 'Receipt Note'),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 16 * 2 - 8 * 3) / 4,
                        child: StatCard(
                          title: "Delivery Note",
                          value: summary['delivery_note']?.toString() ?? "0",
                          onTap: () => _showDetailDialog(context, 'Delivery Note'),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 16 * 2 - 8 * 3) / 4,
                        child: StatCard(
                          title: "Internal Transfer",
                          value: summary['internal_transfer']?.toString() ?? "0",
                          onTap: () => _showDetailDialog(context, 'Internal Transfer'),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 16 * 2 - 8 * 3) / 4,
                        child: StatCard(
                          title: "Stock count",
                          value: summary['stock_count']?.toString() ?? "0",
                          onTap: () => _showDetailDialog(context, 'Stock count'),
                        ),
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
                          value: summary['product_total']?.toString() ?? "0",
                          width: 150,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "On Hand Stock",
                          value: summary['on_hand_stock']?.toString() ?? "0",
                          valueColor: Colors.teal,
                          width: 150,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "Low Stock Alert",
                          value: summary['low_stock_alert']?.toString() ?? "0",
                          valueColor: Colors.orange,
                          width: 150,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          title: "Expiring Soon",
                          value: summary['expiring_soon']?.toString() ?? "0",
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
                            data: stockByWarehouseData,
                            title: "Stok per Gudang",
                          )
                        : StockPieChart(
                            key: const ValueKey('location'),
                            data: stockByLocationData,
                            title: "Stok per Lokasi",
                          ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegend(
                    _selectedStockView == 0
                        ? stockByWarehouseData
                        : stockByLocationData,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Top 5 Hand Stock"),
                  const SizedBox(height: 8),
                  TopProductList(topProducts: topProducts),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Product Category"),
                  const SizedBox(height: 16),
                  ProductBarChart(data: productCategoryData),
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
                            data: stockMovesByProductData,
                            barColor: Colors.green,
                          )
                        : ProductBarChart(
                            key: const ValueKey('moves_location'),
                            data: stockMovesByLocationData,
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
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data
          .map(
            (d) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: d.color),
                const SizedBox(width: 6),
                Text(d.label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          )
          .toList(),
    );
  }
}