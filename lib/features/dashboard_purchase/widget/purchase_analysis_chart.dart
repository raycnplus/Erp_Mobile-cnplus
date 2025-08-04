
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';

class PurchaseAnalysisChart extends StatelessWidget {
  final List<MonthlyPurchaseData> purchaseData;
  final Color mainColor = const Color(0xFF029379);

  const PurchaseAnalysisChart({super.key, required this.purchaseData});

  String _formatYAxisLabel(double value) {
    if (value >= 1000000000) return '${(value / 1000000000).toStringAsFixed(0)}B';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(0)}M';
    if (value >= 100000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'purchase analysis',
              style: TextStyle(
                color: mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineTouchData: _buildLineTouchData(),
                  gridData: _buildGridData(),
                  titlesData: _buildTitlesData(),
                  borderData: _buildBorderData(),
                  lineBarsData: [_buildLineBarsData()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.white,
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final monthYear = '${spot.x.toInt()}-2025';
            final amount = NumberFormat.compactCurrency(
              locale: 'id_ID',
              symbol: '',
              decimalDigits: 2,
            ).format(spot.y);

            return LineTooltipItem(
              '$monthYear\n',
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'total invoice: $amount',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.orange, strokeWidth: 2),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 6,
                    color: Colors.orange,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
            ),
          );
        }).toList();
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, TitleMeta meta) {
            return SideTitleWidget(
              meta: meta, // wajib sekarang
              space: 8,
              child: Text(
                '${value.toInt()}-2025',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(_formatYAxisLabel(value), style: TextStyle(color: Colors.grey.shade700, fontSize: 12), textAlign: TextAlign.left);
          },
        ),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
        dashArray: [8, 4],
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
        left: const BorderSide(color: Colors.transparent),
      ),
    );
  }

  LineChartBarData _buildLineBarsData() {
    return LineChartBarData(
      spots: purchaseData.map((data) => FlSpot(data.month.toDouble(), data.amount)).toList(),
      isCurved: true,
      color: mainColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [mainColor.withOpacity(0.3), mainColor.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

extension on TitleMeta {
  get side => null;
}