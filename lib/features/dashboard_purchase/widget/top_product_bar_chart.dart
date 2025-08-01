import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/purchase_dashboard_models.dart';

class TopProductBarChart extends StatelessWidget {
  final List<TopProduct> products;

  const TopProductBarChart({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(show: true),
          barGroups: products.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.quantity.toDouble(),
                  color: const Color.fromARGB(255, 33, 132, 5),
                  width: 16,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}