import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';
import '../utils/formatters.dart'; 

class PurchaseAnalysisChart extends StatelessWidget {
  final List<MonthlyPurchaseData> purchaseData;
  final Color mainColor = const Color(0xFF029379); 

  const PurchaseAnalysisChart({super.key, required this.purchaseData});

  String _getDateRange() {
    if (purchaseData.isEmpty) {
      return 'Data not available';
    }
    final firstMonth = DateFormat('MMM yyyy').format(DateTime(2025, purchaseData.first.month));
    final lastMonth = DateFormat('MMM yyyy').format(DateTime(2025, purchaseData.last.month));
    return '$firstMonth - $lastMonth';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, 
      shadowColor: mainColor.withAlpha(26), // 0.1
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
                  'Purchase Analysis',
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
                _getDateRange(), // Rentang waktu dinamis
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
            const SizedBox(height: 8), 
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Data processed from ERP",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
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
        getTooltipColor: (touchedSpot) => mainColor.withAlpha(230), // 0.9
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final monthName = DateFormat('MMM').format(DateTime(0, spot.x.toInt()));
            final amount = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(spot.y);

            return LineTooltipItem(
              '$monthName 2025\n',
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
              color: mainColor.withAlpha(128), // 0.5
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
      spots: purchaseData.map((data) => FlSpot(data.month.toDouble(), data.amount)).toList(),
      isCurved: true,
      color: mainColor,
      barWidth: 4, 
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false), 
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            mainColor.withAlpha(128), // 0.5
            mainColor.withAlpha(0),   // 0.0
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}