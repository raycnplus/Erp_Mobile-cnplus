import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/purchase_dashboard_models.dart';

class InvoiceLineChart extends StatelessWidget {
  final List<MonthlyInvoice> invoices;

  const InvoiceLineChart({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: invoices.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.amount);
              }).toList(),
              isCurved: true,
              color: const Color.fromARGB(255, 57, 119, 9),
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}