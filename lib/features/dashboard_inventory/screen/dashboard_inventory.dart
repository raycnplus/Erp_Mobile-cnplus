import 'package:flutter/material.dart';

import '../models/chart_data_model.dart';
import '../models/top_product_model.dart';
import '../widget/bar_chart_widget.dart';
import '../widget/pie_chart_widget.dart';
import '../widget/stat_card_widget.dart';
import '../widget/dashboard_drawer_widget.dart';
import '../widget/top_product_widget.dart';
import '../../../core/routes/app_routes.dart';

class DashboardInventoryScreen extends StatefulWidget {
  const DashboardInventoryScreen({super.key});

  @override
  State<DashboardInventoryScreen> createState() =>
      _DashboardInventoryScreenState();
}

class _DashboardInventoryScreenState extends State<DashboardInventoryScreen> {
  int _selectedStockView = 0;
  int _selectedStockMovesView = 0;

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

  final List<ChartData> productCategoryData = [
    ChartData(label: "Elektronik", value: 22, color: Colors.cyan),
    ChartData(label: "Fashion", value: 20, color: Colors.cyan),
    ChartData(label: "ATK", value: 12, color: Colors.cyan),
    // ...
  ];
  final List<ChartData> stockMovesByProductData = [
    ChartData(label: "Yamaha Aer...", value: 23, color: Colors.green),
    ChartData(label: "Gatsby", value: 22, color: Colors.green),
    // ...
  ];
  final List<ChartData> stockMovesByLocationData = [
    ChartData(label: "Jakarta", value: 58, color: Colors.amber),
    ChartData(label: "Tangerang", value: 40, color: Colors.amber),
    // ...
  ];
  final List<ChartData> stockByWarehouseData = [];
  final List<ChartData> stockByLocationData = [];

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
        'Inventory Dashboard',
      style: TextStyle(color: Colors.black),
     ),
   ),
   backgroundColor: Colors.white,
   elevation: 1,
   iconTheme: const IconThemeData(color: Colors.black),
),
      drawer: const DashboardDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
                children: [
                  StatCardLoader(
                    title: "Receipt Note",
                    endpoint: "inventory/receipt-note",
                    enableAutoRefresh: true,
                    refreshInterval: const Duration(seconds: 30),
                    onTap: () => _showDetailDialog(context, 'Receipt Note'),
                  ),
                  StatCardLoader(
                    title: "Delivery Note",
                    endpoint: "inventory/delivery-note",
                    onTap: () => _showDetailDialog(context, 'Delivery Note'),
                  ),
                  StatCardLoader(
                    title: "Internal Transfer",
                    endpoint: "inventory/internal-transfer",
                    onTap: () =>
                        _showDetailDialog(context, 'Internal Transfer'),
                  ),
                  StatCardLoader(
                    title: "Stock count",
                    endpoint: "inventory/stock-count",
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
                    StatCardLoader(
                      title: "Product",
                      endpoint: "inventory/products",
                      width: 150,
                    ),
                    const SizedBox(width: 10),
                    StatCardLoader(
                      title: "On Hand Stock",
                      endpoint: "inventory/stock/on-hand",
                      valueColor: Colors.teal,
                      width: 150,
                    ),
                    const SizedBox(width: 10),
                    StatCardLoader(
                      title: "Low Stock Alert",
                      endpoint: "inventory/stock/low-stock-alert",
                      valueColor: Colors.orange,
                      width: 150,
                    ),
                    const SizedBox(width: 10),
                    StatCardLoader(
                      title: "Expiring Soon",
                      endpoint: "inventory/stock/expiring-soon",
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
                        endpoint: "stock-by-warehouse",
                        title: "Stok per Gudang",
                      )
                    : StockPieChart(
                        key: const ValueKey('location'),
                        endpoint: "stock-by-location",
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
              // TOP PRODUCTS
              TopProductList(
                endpoint: "https://erp.sorlem.com/api/inventory/top-products",
              ),
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
