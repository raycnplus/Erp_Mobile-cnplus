import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales_chart_data_model.dart';
import '../helpers/currency_helper.dart';

// FUNGSI BARU DITAMBAHKAN DI SINI
String formatShortNumber(double num) {
  if (num > 999999) {
    return '${(num / 1000000).toStringAsFixed(1)}M';
  } else if (num > 999) {
    return '${(num / 1000).toStringAsFixed(1)}k';
  } else {
    return num.toStringAsFixed(0);
  }
}

class SalesBarChart extends StatelessWidget {
  final List<SalesChartData> data;
  final String title;

  const SalesBarChart({super.key, required this.data, required this.title});

  double get _maxDataValue {
    if (data.isEmpty) return 0;
    return data.map((d) => d.value).reduce(max);
  }

  double _calculateInterval() {
    final maxVal = _maxDataValue;
    if (maxVal <= 0) return 10;
    final double roughInterval = maxVal / 5;

    if (roughInterval <= 5) return 5;
    if (roughInterval <= 10) return 10;
    if (roughInterval <= 20) return 20;
    if (roughInterval <= 50) return 50;
    return (roughInterval / 50).ceil() * 50;
  }

  double _calculateMaxY() {
    final maxVal = _maxDataValue;
    final interval = _calculateInterval();
    if (maxVal <= 0) return 50;
    // Memberi sedikit ruang di atas bar tertinggi
    return (maxVal / interval).ceil() * interval;
  }

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
                Container(width: 12, height: 12, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  title.contains("Revenue") ? 'Total Revenue' : 'Total Quantity',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                              // Menggunakan formatCurrency jika Revenue, jika tidak format biasa
                              text: title.contains("Revenue")
                                  ? formatCurrency(rod.toY)
                                  : formatShortNumber(rod.toY),
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
                        reservedSize: 50, // Ruang lebih untuk label
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
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(),
                    getDrawingHorizontalLine: (value) {
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
                          color: Colors.teal,
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
      fontSize: 12, // Disesuaikan agar tidak terlalu besar
      fontWeight: FontWeight.w500,
    );

    String text = data.length > value.toInt() ? data[value.toInt()].label : '';

    return SideTitleWidget(
      meta: meta,
      space: 8.0,
      child: Text(text, style: style),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    final style = TextStyle(color: Colors.grey.shade600, fontSize: 12);

    if (value == 0) return const SizedBox.shrink();

    if (value % _calculateInterval() != 0 && value != _calculateMaxY()) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(formatShortNumber(value), style: style),
    );
  }
}