import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';

class StockPieChart extends StatefulWidget {
  final List<ChartItem> data;
  final String? title;
  final double aspectRatio;

  const StockPieChart({
    super.key,
    required this.data,
    this.title,
    this.aspectRatio = 1.5,
  });

  @override
  State<StockPieChart> createState() => _StockPieChartState();
}

class _StockPieChartState extends State<StockPieChart> {
  int touchedIndex = -1;

  String _formatNumber(double number) =>
      NumberFormat('#,##0', 'id_ID').format(number);

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const Center(child: Text("No data"));

    final double total = widget.data.fold(0, (sum, item) => sum + item.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                blurRadius: 20,
                spreadRadius: -5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          touchedIndex = (!event.isInterestedForInteractions ||
                                  response?.touchedSection == null)
                              ? -1
                              : response!.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData:       FlBorderData(show: false),
                    sectionsSpace:    1.5,
                    centerSpaceRadius: 45,
                    sections:         _buildSections(total),
                  ),
                ),
                _buildCenterText(total),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterText(double total) {
    if (touchedIndex == -1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Total Stok", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 2),
          Text(_formatNumber(total),
              style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
    }

    final touched = widget.data[touchedIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          touched.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          _formatNumber(touched.value),
          style: TextStyle(color: touched.color, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    return List.generate(widget.data.length, (i) {
      final isTouched  = i == touchedIndex;
      final item       = widget.data[i];
      final hsl        = HSLColor.fromColor(item.color);
      final lightColor = hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
      final textColor  = item.color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
      final percentage = total > 0 ? (item.value / total) * 100 : 0;

      return PieChartSectionData(
        color:    Colors.transparent,
        gradient: LinearGradient(
          colors: [lightColor, item.color],
          begin: Alignment.topCenter,
          end:   Alignment.bottomCenter,
        ),
        borderSide: const BorderSide(color: Color.fromARGB(204, 255, 255, 255), width: 1.5),
        value:  item.value,
        title:  percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        radius: isTouched ? 60.0 : 55.0,
        titleStyle: TextStyle(
          fontSize:   isTouched ? 14.0 : 10.0,
          fontWeight: FontWeight.bold,
          color:      textColor,
          shadows:    const [],
        ),
      );
    });
  }
}