import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/purchase_models.dart';
import '../widget/purchase_analysis_chart.dart';
import '../widget/top_list_card.dart';
import '../widget/stat_card_widget.dart';
import '../models/purchase_chart_data_model.dart';
import '../widget/purchase_bar_chart_widget.dart';
import '../widget/purchase_dashboard_drawer_widget.dart';
import '../services/purchase_service.dart';
import '../../../core/routes/app_routes.dart';
import '../models/purchase_dashboard_model.dart' as ApiModel;
import '../utils/formatters.dart'; // Import formatter: fungsi nya buat angka supaya ga panjang dan di pisah biar ga ribet karna lumayan banyak

class DashboardPurchaseScreen extends StatefulWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  State<DashboardPurchaseScreen> createState() =>
      _DashboardPurchaseScreenState();
}

class _DashboardPurchaseScreenState extends State<DashboardPurchaseScreen> {
  Future<ApiModel.PurchaseDashboardResponse>? _dashboardDataFuture;
  // -----------------

  final PurchaseService _purchaseService = PurchaseService();
  int _selectedChart = 0;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _purchaseService.fetchDashboardData();
  }

  // Helper method to transform API data to Chart data
  List<PurchaseChartData> _transformToProductChartData(
      List<ApiModel.TopProduct> products) {
    return products
        .map((p) => PurchaseChartData(
              label: p.productName,
              value: p.totalSpent,
              color: Colors.pinkAccent,
            ))
        .toList();
  }

  List<PurchaseChartData> _transformToVendorChartData(
      List<ApiModel.TopVendor> vendors) {
    return vendors
        .map((v) => PurchaseChartData(
              label: v.vendorName,
              value: v.totalSpent,
              color: Colors.cyan,
            ))
        .toList();
  }

  // Helper method to transform API data to Analysis Chart data
  List<MonthlyPurchaseData> _transformToAnalysisData(
      ApiModel.SpendingByMonth spending) {
    List<MonthlyPurchaseData> chartData = [];
    for (int i = 0; i < spending.labels.length; i++) {
      // Extract month number from "MM-YYYY" label
      final month = int.tryParse(spending.labels[i].split('-')[0]) ?? (i + 1);
      chartData.add(MonthlyPurchaseData(
        month: month,
        amount: spending.data[i],
      ));
    }
    return chartData;
  }

  // Helper methods to transform API data to TopListData
  List<TopListData> _transformToCategoryList(
      List<ApiModel.TopCategory> categories) {
    return categories
        .map((c) => TopListData(
              title: c.productCategoryName,
              value: formatCurrency(c.totalAmount),
            ))
        .toList();
  }

  List<TopListData> _transformToPurchaseOrderList(
      List<ApiModel.TopPurchaseOrder> orders) {
    return orders
        .map((o) => TopListData(
              title: o.reference,
              value: formatCurrency(o.totalAmount),
            ))
        .toList();
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
        'Dashboard Purchase',
      style: TextStyle(color: Colors.black),
     ),
   ),
   backgroundColor: Colors.white,
   elevation: 1,
   iconTheme: const IconThemeData(color: Colors.black),
),
      drawer: const PurchaseDashboardDrawer(),
      body: FutureBuilder<ApiModel.PurchaseDashboardResponse>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          final summary = data.summary;

          final top5ProductData = _transformToProductChartData(data.topProducts);
          final top5VendorData = _transformToVendorChartData(data.topVendors);
          final purchaseAnalysisData =
              _transformToAnalysisData(data.charts.spendingByMonth);
          final topCategoryData = _transformToCategoryList(data.topCategories);
          final topPurchaseOrderData =
              _transformToPurchaseOrderList(data.topPurchaseOrders);

          return SingleChildScrollView(
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
                  children: [
                    StatCard(
                      title: "Purchase Request",
                      value: summary.purchaseRequest.toString(),
                      valueColor: const Color(0xFF029379),
                    ),
                    StatCard(
                      title: "Request For Quotation",
                      value: summary.rfq.toString(),
                      valueColor: const Color(0xFF029379),
                    ),
                    StatCard(
                      title: "Purchase Order",
                      value: summary.purchaseOrder.toString(),
                      valueColor: const Color(0xFF029379),
                    ),
                    StatCard(
                      title: "Direct Purchase",
                      value: summary.directPurchase.toString(),
                      valueColor: const Color(0xFF029379),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Toggle Bar Chart
                LayoutBuilder(
                  builder: (context, constraints) {
                    return ToggleButtons(
                      isSelected: [_selectedChart == 0, _selectedChart == 1],
                      onPressed: (index) {
                        setState(() {
                          _selectedChart = index;
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
                      children: const [
                        Text("Top 5 Product"),
                        Text("Top 5 Vendor")
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Bar Chart
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedChart == 0
                      ? PurchaseBarChart(
                          key: const ValueKey('top5product'),
                          data: top5ProductData,
                          title: "Top 5 Product",
                        )
                      : PurchaseBarChart(
                          key: const ValueKey('top5vendor'),
                          data: top5VendorData,
                          title: "Top 5 Vendor",
                        ),
                ),
                const SizedBox(height: 24),

                // Grafik Analisis
                PurchaseAnalysisChart(purchaseData: purchaseAnalysisData),
                const SizedBox(height: 24),

                // Daftar Top 5 Category
                TopListCard(
                  title: 'Top 5 Category Product',
                  items: topCategoryData,
                ),
                const SizedBox(height: 24),

                // Daftar Top 5 Purchase Order
                TopListCard(
                  title: 'Top 5 Purchase Order',
                  items: topPurchaseOrderData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}