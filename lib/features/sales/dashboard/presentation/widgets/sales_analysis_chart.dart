import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class MonthlySalesData {
  final int month;
  final int year;
  final double amount;

  const MonthlySalesData({
    required this.month,
    required this.year,
    required this.amount,
  });
}

class SalesAnalysisChart extends StatelessWidget {
  final List<MonthlySalesData> salesData;
  final Color mainColor;

  const SalesAnalysisChart({
    super.key,
    required this.salesData,
    this.mainColor = const Color(0xFF409c9c),
  });

  String _getDateRange() {
    if (salesData.isEmpty) {
      return 'Data not available';
    }
    final firstMonth = DateFormat('MMM yyyy')
        .format(DateTime(salesData.first.year, salesData.first.month));
    final lastMonth = DateFormat('MMM yyyy')
        .format(DateTime(salesData.last.year, salesData.last.month));
    return '$firstMonth - $lastMonth';
  }

  @override
  Widget build(BuildContext context) {
    if (salesData.isEmpty) {
      return Card(
        elevation: 4,
        shadowColor: mainColor.withAlpha(26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: const SizedBox(
          height: 200,
          child: Center(child: Text('No data available')),
        ),
      );
    }

    return Card(
      elevation: 4,
      shadowColor: mainColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart_rounded, color: mainColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Sales Per Date',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                _getDateRange(),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
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
                  borderData: FlBorderData(show: false),
                  lineBarsData: [_buildLineBarsData()],
                  minX: 1,
                  maxX: 12,
                  minY: 0,
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
        getTooltipColor: (touchedSpot) => mainColor.withAlpha(230),
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final monthName = DateFormat('MMM').format(DateTime(0, spot.x.toInt()));
            final amount = formatCurrency(spot.y);

            return LineTooltipItem(
              '$monthName ${spot.x == salesData.first.month.toDouble() ? salesData.first.year : salesData.last.year}\n',
              GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              children: [
                TextSpan(
                  text: amount,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white),
                ),
              ],
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: mainColor.withAlpha(128), 
              strokeWidth: 2,
              dashArray: [4, 4],
            ),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 6,
                color: mainColor,
                strokeWidth: 3,
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
          interval: 2,
          getTitlesWidget: (value, meta) {
            final monthName = DateFormat('MMM').format(DateTime(0, value.toInt()));
            return SideTitleWidget(
              meta: meta,
              space: 8,
              child: Text(
                monthName,
                style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 11),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          getTitlesWidget: (value, meta) {
            if (value == meta.max || value == meta.min) {
              return const SizedBox();
            }
            return Text(
              formatCurrency(value),
              style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 11),
              textAlign: TextAlign.left,
            );
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
      ),
    );
  }

  LineChartBarData _buildLineBarsData() {
    return LineChartBarData(
      spots: salesData.map((data) => FlSpot(data.month.toDouble(), data.amount)).toList(),
      isCurved: true,
      color: mainColor,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            mainColor.withAlpha(128), 
            mainColor.withAlpha(0), 
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}