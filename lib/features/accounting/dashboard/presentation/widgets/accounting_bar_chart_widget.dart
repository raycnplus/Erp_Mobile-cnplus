import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

const Color kDefaultBarColor = Color(0xFF029379);

class AccountingBarChart extends StatelessWidget {
  final List<AccountingChartData> data;
  final String title;

  const AccountingBarChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No data available',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
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
            Text(
              title,
              style: GoogleFonts.poppins(
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
                Text(
                  'Total Amount',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${data[groupIndex].label}\n',
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: formatCurrency(rod.toY),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getBottomTitles,
                        reservedSize: 50,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getLeftTitles,
                        reservedSize: 55,
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
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
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
                          color: d.color ?? kDefaultBarColor,
                          width: 28,
                          borderRadius: BorderRadius.circular(4),
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
    final originalText = data.length > value.toInt() ? data[value.toInt()].label : '';
    const int maxLength = 12;
    String finalText = originalText.length > maxLength 
        ? '${originalText.substring(0, maxLength - 3)}...' 
        : originalText;

    return SideTitleWidget(
      meta: meta,
      space: 8,
      angle: -0.5,
      child: Text(
        finalText,
        style: GoogleFonts.poppins(
          color: Colors.grey.shade600,
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    if (value == 0) return const SizedBox();
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        formatCurrency(value),
        style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 10),
        textAlign: TextAlign.left,
      ),
    );
  }

  double _calculateMaxY() {
    if (data.isEmpty) return 100;
    double maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2;
  }
}