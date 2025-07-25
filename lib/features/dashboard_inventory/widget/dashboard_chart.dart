import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildBarChart(),
        const SizedBox(height: 20),
        buildBarChart(),
      ],
    );
  }

  Widget buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 25,
          barGroups: [
            makeGroup(0, 23),
            makeGroup(1, 20),
            makeGroup(2, 14),
            makeGroup(3, 13),
            makeGroup(4, 9),
          ],
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData makeGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
            toY: y, color: const Color(0xFF0D5B5B), width: 18)
      ],
    );
  }
}
