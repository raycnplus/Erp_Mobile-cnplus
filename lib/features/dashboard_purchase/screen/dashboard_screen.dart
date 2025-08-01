import 'package:flutter/material.dart';
import '../widget/invoice_line_chart.dart';
import '../models/purchase_dashboard_models.dart';

class DashboardPurchaseScreen extends StatelessWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MonthlyInvoice> dummyInvoices = [
      MonthlyInvoice(month: 'Jan', amount: 120000),
      MonthlyInvoice(month: 'Feb', amount: 95000),
      MonthlyInvoice(month: 'Mar', amount: 143000),
      MonthlyInvoice(month: 'Apr', amount: 87000),
      MonthlyInvoice(month: 'May', amount: 160000),
      MonthlyInvoice(month: 'Jun', amount: 110000),
    ];

    final List<Map<String, dynamic>> recentPurchases = [
      {'item': 'Printer Canon', 'date': '2025-07-28', 'amount': 1500000},
      {'item': 'Kertas A4', 'date': '2025-07-27', 'amount': 250000},
      {'item': 'Tinta Epson', 'date': '2025-07-25', 'amount': 320000},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pembelian'),
        backgroundColor: const Color.fromARGB(255, 6, 108, 26),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard('Total Pembelian', 'Rp 3.250.000', Icons.shopping_cart),
                _buildSummaryCard('Faktur Bulan Ini', 'Rp 870.000', Icons.receipt),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Grafik Faktur Bulanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InvoiceLineChart(invoices: dummyInvoices),
            const SizedBox(height: 24),
            const Text(
              'Pembelian Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recentPurchases.map((purchase) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag, color: Color.fromARGB(255, 10, 83, 9)),
                    title: Text(purchase['item']),
                    subtitle: Text(purchase['date']),
                    trailing: Text(
                      'Rp ${purchase['amount'].toString()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
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
}