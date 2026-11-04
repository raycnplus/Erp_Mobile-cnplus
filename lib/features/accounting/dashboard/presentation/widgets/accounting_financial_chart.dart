import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class AccountingFinancialChart extends StatelessWidget {
  final FinancialPerformanceData data;
  final String title;

  const AccountingFinancialChart({super.key, required this.data, required this.title});

  static const _names = ['Revenue', 'Expense', 'Receivable', 'Profit'];
  static const _colors = [
    Color(0xFF16A34A),
    Color(0xFFF4B400),
    Color(0xFFD93025),
    Color(0xFF0D47A1),
  ];

  List<List<double>> get _series => [data.revenue, data.expense, data.receivable, data.profit];

  @override
  Widget build(BuildContext context) {
    if (data.labels.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text('No data available',
                style: GoogleFonts.poppins(color: Colors.grey.shade600)),
          ),
        ),
      );
    }

    final all = _series.expand((e) => e).toList();
    final maxV = all.isEmpty ? 0.0 : all.reduce(math.max);
    final minV = all.isEmpty ? 0.0 : all.reduce(math.min);
    final maxY = maxV <= 0 ? 100.0 : maxV * 1.2;
    final minY = minV >= 0 ? 0.0 : minV * 1.2;

    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = math.max(screenWidth - 64, data.labels.length * 64.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: List.generate(
                _names.length,
                (i) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, color: _colors[i]),
                    const SizedBox(width: 6),
                    Text(_names[i],
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                height: 280,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: math.max(data.labels.length - 1, 1).toDouble(),
                    minY: minY,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => Colors.black87,
                        tooltipBorderRadius: BorderRadius.circular(8),
                        getTooltipItems: (spots) => spots.map((s) {
                          return LineTooltipItem(
                            '${_names[s.barIndex]}: ${formatCurrency(s.y)}',
                            GoogleFonts.poppins(
                              color: _colors[s.barIndex] == const Color(0xFF0D47A1)
                                  ? Colors.lightBlueAccent
                                  : _colors[s.barIndex],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (value != i.toDouble() || i < 0 || i >= data.labels.length) {
                              return const SizedBox();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                data.labels[i],
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) => SideTitleWidget(
                            meta: meta,
                            child: Text(
                              formatCurrency(value),
                              style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    lineBarsData: List.generate(_series.length, (s) {
                      final values = _series[s];
                      return LineChartBarData(
                        spots: List.generate(
                          data.labels.length,
                          (i) => FlSpot(i.toDouble(), i < values.length ? values[i] : 0),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        preventCurveOverShooting: true,
                        color: _colors[s],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}