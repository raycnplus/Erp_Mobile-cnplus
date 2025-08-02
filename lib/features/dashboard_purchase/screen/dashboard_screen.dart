import 'package:flutter/material.dart';
import '../widget/invoice_line_chart.dart';
import '../widget/stat_card.dart';
import '../widget/top_product_bar_chart.dart';
import '../models/purchase_dashboard_models.dart';
import '../../../services/purchase_dashboard_service.dart';
// Ensure that PurchaseDashboardService is defined in the imported file as a class.

class DashboardPurchaseScreen extends StatefulWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  State<DashboardPurchaseScreen> createState() => _DashboardPurchaseScreenState();
}

class _DashboardPurchaseScreenState extends State<DashboardPurchaseScreen> {
  late Future<DashboardData> dashboardData;

  @override
  void initState() {
  dashboardData = PurchaseDashboardService().fetchDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pembelian'),
        backgroundColor: const Color.fromARGB(255, 6, 108, 26),
      ),
      body: FutureBuilder<DashboardData>(
        future: dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StatCard(title: 'Purchase Request', value: '52'),
                  const SizedBox(width: 12),
                  StatCard(title: 'Request For Quotation', value: '28'),
                  const SizedBox(width: 12),
                  StatCard(title: 'Purchase Order', value: '27'),
                  const SizedBox(width: 12),
                  StatCard(title: 'Direct Purchase', value: '19'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.indigo),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }