import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/sales_dashboard_model.dart';
import '../models/sales_chart_data_model.dart';
import '../widget/stat_card_widget.dart';
import '../widget/sales_bar_chart_widget.dart';
import '../widget/top_list_card.dart';
import '../widget/sales_dashboard_drawer_widget.dart';

class DashboardSalesScreen extends StatefulWidget {
  const DashboardSalesScreen({super.key});

  @override
  State<DashboardSalesScreen> createState() => _DashboardSalesScreenState();
}

class _DashboardSalesScreenState extends State<DashboardSalesScreen> {
  late Future<SalesDashboardResponse> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchDashboardData();
  }

  Future<SalesDashboardResponse> _fetchDashboardData() async {
    final response = await http.get(Uri.parse('https://erp.sorlem.com/api/sales'));
    if (response.statusCode == 200) {
      return SalesDashboardResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sales dashboard');
    }
  }

  String formatCurrency(double value) {
    if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return 'Rp ${value.toStringAsFixed(0)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SalesDashboardDrawer(),
      backgroundColor: const Color(0xFFEAFBF3),
      appBar: AppBar(
        title: const Text('Dashboard Sales', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: FutureBuilder<SalesDashboardResponse>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }
          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.8,
                  children: [
                    StatCard(title: "Quotations", value: data.quotation.toString()),
                    StatCard(title: "Sales Order", value: data.salesOrder.toString()),
                    StatCard(title: "Direct Sales", value: data.directSales.toString()),
                    StatCard(title: "Invoices", value: data.invoice.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                  children: [
                    StatCard(title: "Products", value: data.salesProductCount.toString()),
                    StatCard(title: "Revenue", value: formatCurrency(data.grandTotal)),
                  ],
                ),
                const SizedBox(height: 24),
                SalesBarChart(
                  data: data.revenuePerDay,
                  title: "Daily Revenue",
                ),
                const SizedBox(height: 24),
                SalesBarChart(
                  data: data.quantityPerDay,
                  title: "Quantity Sold",
                ),
                const SizedBox(height: 24),
                TopListCard(
                  title: "Top 5 Customers",
                  items: data.topCustomers.map((c) => [
                    c.customerName,
                    c.categoryName,
                    formatCurrency(c.totalAmount),
                  ]).toList(),
                ),
                const SizedBox(height: 24),
                TopListCard(
                  title: "Top 5 Invoices",
                  items: data.topInvoices.map((i) => [
                    i.reference,
                    i.customerName,
                    formatCurrency(i.grandTotal),
                  ]).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}