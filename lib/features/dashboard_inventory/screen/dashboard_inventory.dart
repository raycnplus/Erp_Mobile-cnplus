import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/chart_data_model.dart';
import '../models/product_stock_model.dart';
import '../widget/bar_chart_widget.dart';
import '../widget/pie_chart_widget.dart';
import '../widget/stat_card_widget.dart';

class DashboardInventoryScreen extends StatefulWidget {
  const DashboardInventoryScreen({super.key});

  @override
  State<DashboardInventoryScreen> createState() =>
      _DashboardInventoryScreenState();
}

class _DashboardInventoryScreenState extends State<DashboardInventoryScreen> {
  // Variabel untuk mengontrol toggle button
  int _selectedStockView = 0; // 0 for Warehouse, 1 for Location

  // --- DUMMY DATA ---
  // Ganti data ini dengan data dari API kamu nantinya
  final List<ProductStock> top5Products = [
    ProductStock(name: "Product A", quantity: "1.6 Juta"),
    ProductStock(name: "Product B", quantity: "260 Ribu"),
    ProductStock(name: "Product C", quantity: "165 Ribu"),
    ProductStock(name: "Product D", quantity: "48 Ribu"),
    ProductStock(name: "Product E", quantity: "5 Ribu"),
  ];

  final List<ChartData> stockByWarehouseData = [
    ChartData(label: "Gudang A", value: 67, color: Colors.teal),
    ChartData(label: "Gudang B", value: 21, color: Colors.teal.shade300),
    ChartData(label: "Gudang C", value: 12, color: Colors.teal.shade100),
  ];

  final List<ChartData> stockByLocationData = [
    ChartData(label: "Jakarta", value: 55, color: Colors.orange),
    ChartData(label: "Surabaya", value: 25, color: Colors.orange.shade300),
    ChartData(label: "Bandung", value: 20, color: Colors.orange.shade100),
  ];

  final List<ChartData> productCategoryData = [
    ChartData(label: "Elektronik", value: 22, color: Colors.cyan),
    ChartData(label: "Fashion", value: 20, color: Colors.cyan),
    ChartData(label: "ATK", value: 12, color: Colors.cyan),
    ChartData(label: "Otomotif", value: 11, color: Colors.cyan),
    ChartData(label: "Perkakas", value: 8, color: Colors.cyan),
  ];
  // --- END OF DUMMY DATA ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/hamburger_menu.svg', // Pastikan kamu punya ikon ini di folder assets
            height: 24,
          ),
          onPressed: () {
            // Aksi untuk membuka drawer/menu
          },
        ),
        title: const Text(
          'Dashboard Inventory',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Kartu Statistik Atas
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
                children: const [
                  StatCard(title: "Receipt Note", value: "0"),
                  StatCard(title: "Delivery Note", value: "0"),
                  StatCard(title: "Delivery Note", value: "0"),
                  StatCard(title: "On Hand Stock", value: "2.7M", valueColor: Colors.teal),
                  StatCard(title: "Low Stock Alert", value: "144", valueColor: Colors.orange),
                  StatCard(title: "Expiring Soon", value: "144", valueColor: Colors.red),
                ],
              ),
              const SizedBox(height: 24),

              // Bagian Grafik Stok
              _buildSectionTitle("Stock"),
              const SizedBox(height: 16),
              _buildStockToggleButtons(),
              const SizedBox(height: 16),
              // Menampilkan Pie Chart berdasarkan toggle yang aktif
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedStockView == 0
                    ? StockPieChart(key: const ValueKey('warehouse'), data: stockByWarehouseData)
                    : StockPieChart(key: const ValueKey('location'), data: stockByLocationData),
              ),
              _buildLegend(_selectedStockView == 0 ? stockByWarehouseData : stockByLocationData),
              const SizedBox(height: 24),

              // Bagian Top 5 Hand Stock
              _buildSectionTitle("Top 5 Hand Stock"),
              const SizedBox(height: 8),
              _buildTopStockList(),
              const SizedBox(height: 24),

              // Bagian Grafik Kategori Produk
              _buildSectionTitle("Product Category"),
              const SizedBox(height: 16),
              ProductBarChart(data: productCategoryData),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk judul setiap bagian
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Widget untuk toggle button
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
          constraints: BoxConstraints.expand(width: constraints.maxWidth / 2 - 2, height: 40),
          children: const [
            Text("Stock by Warehouse"),
            Text("Stock per Location"),
          ],
        );
      },
    );
  }

  // Widget untuk legenda di bawah Pie Chart
  Widget _buildLegend(List<ChartData> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.map((d) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, color: d.color),
          const SizedBox(width: 6),
          Text(d.label, style: const TextStyle(fontSize: 12)),
        ],
      )).toList(),
    );
  }

  // Widget untuk menampilkan daftar Top 5 Stok
  Widget _buildTopStockList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("QTY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const Divider(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: top5Products.length,
              itemBuilder: (context, index) {
                final product = top5Products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name),
                      Text(
                        product.quantity,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            )
          ],
        ),
      ),
    );
  }
}