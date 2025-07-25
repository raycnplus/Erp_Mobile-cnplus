import 'package:flutter/material.dart';
import '../models/dashboard_data_model.dart';

class DashboardCards extends StatelessWidget {
  final DashboardData data;
  const DashboardCards({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            buildCard("Receipt Note", data.receiptNote.toString(), color: const Color(0xFF419C9C)),
            buildCard("Delivery Note", data.deliveryNote.toString(), color: const Color(0xFF419C9C)),
            buildCard("On Hand Stock", data.onHandStock.toString(), color: const Color(0xFF66C6C6)),
            buildCard("Low Stock Alert", data.lowStockAlert.toString(), color: const Color(0xFF0D5B5B)),
          ],
        ),
      ],
    );
  }

  Widget buildCard(String title, String value, {required Color color}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}
