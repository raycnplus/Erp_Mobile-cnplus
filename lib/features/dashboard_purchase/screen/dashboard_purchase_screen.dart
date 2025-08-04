import 'package:flutter/material.dart';
import '../models/purchase_models.dart';
import '../widget/purchase_analysis_chart.dart';
import '../widget/top_list_card.dart';
import '../widget/stat_card_widget.dart';
import '../models/purchase_chart_data_model.dart';
import '../widget/purchase_bar_chart_widget.dart';

class DashboardPurchaseScreen extends StatefulWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  State<DashboardPurchaseScreen> createState() => _DashboardPurchaseScreenState();
}

class _DashboardPurchaseScreenState extends State<DashboardPurchaseScreen> {
  int _selectedChart = 0;

  final List<MonthlyPurchaseData> dummyPurchaseData = [
    MonthlyPurchaseData(month: 1, amount: 20000000),
    MonthlyPurchaseData(month: 2, amount: 85000000),
    MonthlyPurchaseData(month: 3, amount: 15000000),
    MonthlyPurchaseData(month: 4, amount: 95000000),
    MonthlyPurchaseData(month: 5, amount: 120400000),
    MonthlyPurchaseData(month: 6, amount: 90000000),
  ];

  final List<TopListData> topCategoryData = [
    TopListData(title: 'Category A', value: 'Rp 120M'),
    TopListData(title: 'Category B', value: 'Rp 100M'),
    TopListData(title: 'Category C', value: 'Rp 400JT'),
    TopListData(title: 'Category D', value: 'Rp 400JT'),
    TopListData(title: 'Category E', value: 'Rp 200JT'),
  ];

  final List<TopListData> topPurchaseOrderData = [
    TopListData(title: 'Product A', value: 'Rp 120M'),
    TopListData(title: 'Product B', value: 'Rp 95M'),
    TopListData(title: 'Product C', value: 'Rp 80M'),
  ];

  // Dummy data for bar charts
  final List<PurchaseChartData> top5ProductData = [
    PurchaseChartData(label: "Gentle Skin Cleanser Cetaphil", value: 120100970821, color: Colors.pinkAccent),
    PurchaseChartData(label: "Infinix GT 30 PRO", value: 100000000, color: Colors.pinkAccent),
    PurchaseChartData(label: "Dior Homme intense", value: 50000000, color: Colors.pinkAccent),
    PurchaseChartData(label: "Mykonos California", value: 20000000, color: Colors.pinkAccent),
    PurchaseChartData(label: "JPG Le Male Le Parfum", value: 10000000, color: Colors.pinkAccent),
  ];

  final List<PurchaseChartData> top5VendorData = [
    PurchaseChartData(label: "PT Unilever Indonesia", value: 120100970821, color: Colors.cyan),
    PurchaseChartData(label: "PT JPG Fragrance Indonesia", value: 100000000, color: Colors.cyan),
    PurchaseChartData(label: "PT. RioSukaMaju", value: 5000000, color: Colors.cyan),
    PurchaseChartData(label: "Dryy", value: 2000000, color: Colors.cyan),
    PurchaseChartData(label: "Bowo", value: 1000000, color: Colors.cyan),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dashboard Purchase', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
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
              childAspectRatio: 0.7,
              children: const [
                StatCard(title: "Purchase Request", value: "52", valueColor: Color(0xFF029379)),
                StatCard(title: "Request For Quotation", value: "28", valueColor: Color(0xFF029379)),
                StatCard(title: "Purchase Order", value: "27", valueColor: Color(0xFF029379)),
                StatCard(title: "Direct Purchase", value: "19", valueColor: Color(0xFF029379)),
              ],
            ),
            const SizedBox(height: 24),

            // Toggle Bar Chart
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedChart == 0 ? Colors.teal : Colors.white,
                        foregroundColor: _selectedChart == 0 ? Colors.white : Colors.teal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                      ),
                      onPressed: () => setState(() => _selectedChart = 0),
                      child: const Text("Top 5 Product"),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedChart == 1 ? Colors.teal : Colors.white,
                        foregroundColor: _selectedChart == 1 ? Colors.white : Colors.teal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      ),
                      onPressed: () => setState(() => _selectedChart = 1),
                      child: const Text("Top 5 Vendor"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bar Chart
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedChart == 0
                  ? Column(
                      key: const ValueKey('top5product'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            "Top 5 Product",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        PurchaseBarChart(data: top5ProductData, title: "Top 5 Product"),
                      ],
                    )
                  : Column(
                      key: const ValueKey('top5vendor'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            "Top 5 Vendor",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        PurchaseBarChart(data: top5VendorData, title: "Top 5 Vendor"),
                      ],
                    ),
            ),
            const SizedBox(height: 24),

            // Grafik Analisis
            PurchaseAnalysisChart(purchaseData: dummyPurchaseData),
            const SizedBox(height: 24),

            // Daftar Top 5
            TopListCard(title: 'Top 5 Category Product', items: topCategoryData),
            const SizedBox(height: 24),

            // Daftar Top 5
            TopListCard(title: 'Top 5 Purchase Order', items: topPurchaseOrderData),
          ],
        ),
      ),
    );
  }
}