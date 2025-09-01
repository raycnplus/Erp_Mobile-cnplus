import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/purchase_chart_data_model.dart';

const Color kDefaultBarColor = Color(0xFF029379);

class PurchaseBarChart extends StatelessWidget {
  final List<PurchaseChartData> data;
  final String title;

  const PurchaseBarChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(width: 12, height: 12, color: kDefaultBarColor),
                const SizedBox(width: 8),
                const Text(
                  'Total Purchase',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
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
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Rp${rod.toY.round().toString()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
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
                        reservedSize: 50,
                        interval: _calculateInterval(),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      left: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 1,
                    horizontalInterval: _calculateInterval(),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final d = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: d.value,
                          color: kDefaultBarColor,
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
    final style = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    String text = data.length > value.toInt() ? data[value.toInt()].label : '';

    return SideTitleWidget(
      meta: meta,
      space: 8.0,
      child: Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    final style = TextStyle(color: Colors.grey.shade600, fontSize: 12);

    if (value % _calculateInterval() != 0 && value != _calculateMaxY()) {
      return const SizedBox();
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        value == 0 ? '' : 'Rp${value.toInt().toString()}',
        style: style,
      ),
    );
  }

  double _calculateMaxY() {
    double maxVal = 0;
    for (var d in data) {
      if (d.value > maxVal) maxVal = d.value;
    }
    return (maxVal / 5).ceil() * 5.0 + 5;
  }

  double _calculateInterval() {
    double maxVal = 0;
    for (var d in data) {
      if (d.value > maxVal) maxVal = d.value;
    }
    final interval = (maxVal / 5).ceilToDouble();
    return interval > 0 ? interval : 1;
  }
}
