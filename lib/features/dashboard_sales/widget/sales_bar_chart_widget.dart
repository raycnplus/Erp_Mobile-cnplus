import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales_chart_data_model.dart';

class SalesBarChart extends StatelessWidget {
  final List<SalesChartData> data;
  final String title;

  const SalesBarChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: data
                      .asMap()
                      .entries
                      .map((entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.value,
                                color: Colors.teal,
                                width: 18,
                              ),
                            ],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          return Text(
                            idx < data.length ? data[idx].label : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}