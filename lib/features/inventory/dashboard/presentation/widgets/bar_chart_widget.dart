import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

const Color kDefaultBarColor = Color(0xFF029379);

class ProductBarChart extends StatelessWidget {
  final List<ChartItem> data;
  final Color barColor;

  const ProductBarChart({
    super.key,
    required this.data,
    this.barColor = kDefaultBarColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: const SizedBox(
          height: 200,
          child: Center(child: Text("Tidak ada data.")),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Product Category',
              style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(width: 12, height: 12, color: barColor),
                const SizedBox(width: 8),
                const Text('Total Product', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${data[groupIndex].label}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          children: [
                            TextSpan(
                              text: formatShortNumber(rod.toY),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
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
                        getTitlesWidget: _getBottomTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getLeftTitles,
                        reservedSize: 30,
                        interval: _calculateInterval(),
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
                          color: barColor,
                          width: 22,
                          borderRadius: BorderRadius.zero,
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

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= data.length) return const SizedBox.shrink();

    final words     = data[index].label.split(' ');
    final firstWord = words[0];
    final label     = words.length > 1 ? '$firstWord...' : firstWord;

    return SideTitleWidget(
      meta: meta,
      space: 8.0,
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    if (value == 0 || value == meta.max || value % _calculateInterval() != 0) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        value.toInt().toString(),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }

  double get _maxDataValue =>
      data.isEmpty ? 0 : data.map((d) => d.value).reduce(max);

  double _calculateInterval() {
    final maxVal = _maxDataValue;
    if (maxVal <= 0) return 10;
    final rough = maxVal / 5;
    if (rough <= 5)  return 5;
    if (rough <= 10) return 10;
    if (rough <= 20) return 20;
    if (rough <= 50) return 50;
    return (rough / 50).ceil() * 50;
  }

  double _calculateMaxY() {
    final maxVal   = _maxDataValue;
    final interval = _calculateInterval();
    if (maxVal <= 0) return 50;
    return (maxVal / interval).ceil() * interval;
  }
}