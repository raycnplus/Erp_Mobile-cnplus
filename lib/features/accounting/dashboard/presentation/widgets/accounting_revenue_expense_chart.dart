import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class AccountingRevenueExpenseChart extends StatelessWidget {
  final List<RevenueExpenseData> revenueData;
  final List<RevenueExpenseData> expenseData;
  final Color revenueColor = const Color(0xFF029379);
  final Color expenseColor = const Color(0xFFE53935);

  const AccountingRevenueExpenseChart({
    super.key,
    required this.revenueData,
    required this.expenseData,
  });

  double get _maxY {
    double maxVal = 0;
    for (var d in revenueData) {
      if (d.total > maxVal) maxVal = d.total;
    }
    for (var d in expenseData) {
      if (d.total > maxVal) maxVal = d.total;
    }
    return maxVal * 1.2;
  }

  DateTime _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        final day = int.parse(parts[0]);
        final month = _getMonthNumber(parts[1]);
        return DateTime(DateTime.now().year, month, day);
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  int _getMonthNumber(String monthName) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[monthName] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    if (revenueData.isEmpty && expenseData.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No revenue/expense data available',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    final allDates = {...revenueData.map((e) => e.date), ...expenseData.map((e) => e.date)}.toList();
    allDates.sort((a, b) {
      final aDate = _parseDateString(a);
      final bDate = _parseDateString(b);
      return aDate.compareTo(bDate);
    });

    final revenueMap = {for (var d in revenueData) d.date: d.total};
    final expenseMap = {for (var d in expenseData) d.date: d.total};

    return Card(
      elevation: 4,
      shadowColor: revenueColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: revenueColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Revenue vs Expense',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegend(revenueColor, 'Revenue'),
                const SizedBox(width: 16),
                _buildLegend(expenseColor, 'Expense'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineTouchData: _buildLineTouchData(),
                  gridData: _buildGridData(),
                  titlesData: _buildTitlesData(allDates),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _buildLineBarData(
                      revenueMap,
                      allDates,
                      revenueColor,
                    ),
                    _buildLineBarData(
                      expenseMap,
                      allDates,
                      expenseColor,
                    ),
                  ],
                  minX: 0,
                  maxX: (allDates.length - 1).toDouble(),
                  minY: 0,
                  maxY: _maxY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.black87,
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem(
              '${spot.bar.spots[spot.spotIndex].x}\n',
              GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              children: [
                TextSpan(
                  text: formatCurrency(spot.y),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 11, color: Colors.white70),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<String> allDates) {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < allDates.length) {
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  allDates[index],
                  style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 10),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              meta: meta,
              child: Text(
                formatCurrency(value),
                style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 10),
              ),
            );
          },
        ),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
      getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
    );
  }

  LineChartBarData _buildLineBarData(
    Map<String, double> dataMap,
    List<String> allDates,
    Color color,
  ) {
    return LineChartBarData(
      spots: List.generate(allDates.length, (index) {
        final date = allDates[index];
        return FlSpot(index.toDouble(), dataMap[date] ?? 0);
      }),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }
}