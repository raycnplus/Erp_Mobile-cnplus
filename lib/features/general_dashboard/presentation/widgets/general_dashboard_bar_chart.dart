import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class GeneralBarChart extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<double> values;
  final Color color;

  const GeneralBarChart({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    required this.color,
  });

  String _fmtShort(double v) {
    if (v >= 1000000) return 'Rp${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return 'Rp${(v / 1000).toStringAsFixed(1)}k';
    return 'Rp${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final maxY = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 10.0;

    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 20),
            if (values.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No data available',
                    style: GoogleFonts.poppins(color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: maxY * 1.25,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: colorGreyLight, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 52,
                          getTitlesWidget: (v, _) => Text(
                            _fmtShort(v),
                            style: GoogleFonts.poppins(
                                fontSize: 9, color: colorTextSubtle),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (v, _) {
                            final idx = v.toInt();
                            if (idx < 0 || idx >= labels.length) {
                              return const SizedBox();
                            }
                            final name = labels[idx];
                            final short = name.length > 8
                                ? '${name.substring(0, 7)}…'
                                : name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                short,
                                style: GoogleFonts.poppins(
                                    fontSize: 9, color: colorTextSubtle),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: values.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value,
                            color: color,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (g, _, rod, __) => BarTooltipItem(
                          '${g.x < labels.length ? labels[g.x] : ''}\n${_fmtShort(rod.toY)}',
                          GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white),
                        ),
                      ),
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