import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/models/sales_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

String _formatShortNumber(double num) {
  if (num >= 1000000000) return '${(num / 1000000000).toStringAsFixed(1)}B';
  if (num >= 1000000)    return '${(num / 1000000).toStringAsFixed(1)}M';
  if (num >= 1000)       return '${(num / 1000).toStringAsFixed(1)}K';
  return num.toStringAsFixed(0);
}

class SalesBarChart extends StatelessWidget {
  final List<SalesChartData> data;
  final String title;

  const SalesBarChart({super.key, required this.data, required this.title});

  bool get _isRevenue => title.contains("Revenue");

  double get _maxDataValue {
    if (data.isEmpty) return 0;
    return data.map((d) => d.value).reduce(max);
  }

  double _calculateInterval() {
    final maxVal = _maxDataValue;
    if (maxVal <= 0) return 10;
    final rough = maxVal / 5;
    if (rough <= 5)   return 5;
    if (rough <= 10)  return 10;
    if (rough <= 20)  return 20;
    if (rough <= 50)  return 50;
    if (rough <= 100) return 100;
    final magnitude = pow(10, (log(rough) / log(10)).floor()).toDouble();
    return (rough / magnitude).ceil() * magnitude;
  }

  double _calculateMaxY() {
    final maxVal   = _maxDataValue;
    final interval = _calculateInterval();
    if (maxVal <= 0) return 50;
    return (maxVal / interval).ceil() * interval;
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: const SizedBox(
          height: 200,
          child: Center(child: Text('No data available')),
        ),
      );
    }

    final int totalBars  = data.length;
    final int maxLabels  = 6;
    final int labelStep  = totalBars <= maxLabels ? 1 : (totalBars / maxLabels).ceil();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(width: 12, height: 12, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  _isRevenue ? 'Total Revenue' : 'Total Quantity',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${data[groupIndex].label}\n',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                          children: [
                            TextSpan(
                              text: _isRevenue
                                  ? formatCurrency(rod.toY)
                                  : _formatShortNumber(rod.toY),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length) {
                            return const SizedBox.shrink();
                          }
                          if (index % labelStep != 0) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              data[index].label,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: _isRevenue ? 55 : 35,
                        interval: _calculateInterval(),
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          if (value % _calculateInterval() != 0) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              _formatShortNumber(value),
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      left:   BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(),
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value,
                          color: Colors.teal,
                          width: totalBars > 20 ? 8 : totalBars > 10 ? 14 : 20,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}