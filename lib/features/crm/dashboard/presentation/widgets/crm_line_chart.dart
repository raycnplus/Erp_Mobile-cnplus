import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';

class CrmLineChart extends StatelessWidget {
  final String title;
  final CrmChartData? chartData;
  final bool isLoading;
  final CrmGranularity selected;
  final ValueChanged<CrmGranularity> onGranularityChanged;
  final Color lineColor;

  const CrmLineChart({
    super.key,
    required this.title,
    required this.chartData,
    required this.isLoading,
    required this.selected,
    required this.onGranularityChanged,
    this.lineColor = const Color(0xFF2D6A4F),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: lineColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CrmGranularity>(
                      value: selected,
                      isDense: true,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                      items: CrmGranularity.values.map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.label),
                      )).toList(),
                      onChanged: (g) {
                        if (g != null) onGranularityChanged(g);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (chartData == null || chartData!.isEmpty)
                      ? Center(
                          child: Text(
                            'No data',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        )
                      : _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data = chartData!;
    final maxY = data.values.isEmpty
        ? 10.0
        : (data.values.reduce((a, b) => a > b ? a : b) * 1.3).toDouble();

    final spots = data.values.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY == 0 ? 10 : maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
            left: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (v, m) => v % 1 == 0
                  ? Text(
                      v.toInt().toString(),
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                    )
                  : const SizedBox(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (data.labels.length / 5).ceilToDouble().clamp(1, 9999),
              getTitlesWidget: (v, m) {
                final idx = v.toInt();
                if (idx < 0 || idx >= data.labels.length) return const SizedBox();
                return SideTitleWidget(
                  meta: m,
                  space: 4,
                  child: Text(
                    data.labels[idx],
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              final idx = s.x.toInt();
              final label = idx < data.labels.length ? data.labels[idx] : '';
              return LineTooltipItem(
                '$label\n${s.y.toInt()}',
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: spots.length == 1 ? 5 : 3,
                color: lineColor,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withOpacity(0.15),
                  lineColor.withOpacity(0.01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}