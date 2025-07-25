import 'package:flutter/material.dart';
import '../models/dashboard_data_model.dart';
import '../widget/dashboard_cards.dart';
import '../widget/dashboard_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = DashboardData(
      receiptNote: 0,
      deliveryNote: 0,
      onHandStock: 2724854,
      lowStockAlert: 144,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Inventory"),
        backgroundColor: const Color(0xFF66C6C6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardCards(data: dummyData),
            const SizedBox(height: 20),
            const DashboardChart(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE8F7F7), // background pastel
    );
  }
}
