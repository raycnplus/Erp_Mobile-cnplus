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
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < products.length) {
                    return Text(products[index].name, style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: product.quantity.toDouble(),
                  color: const Color.fromARGB(255, 11, 83, 2),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}