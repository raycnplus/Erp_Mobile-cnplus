import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/chart_data_model.dart';

class StockPieChart extends StatefulWidget {
  final List<ChartData> data;
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

  // Helper untuk format angka dengan pemisah ribuan
  String _formatNumber(double number) {
    // Menggunakan NumberFormat dengan locale id_ID
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text("No data"));
    }

    final double totalValue = widget.data.fold(
      0,
      (sum, item) => sum + item.value,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  // Center Radius yang sudah dikecilkan
                  centerSpaceRadius: 45,
                  sections: showingSections(totalValue),
                ),
              ),
              _buildCenterText(totalValue),
            ],
          ),
        ),
      ],
    );
  }

  // === FUNGSI INI TELAH DIOPTIMALKAN FONTNYA ===
  Widget _buildCenterText(double totalValue) {
    if (touchedIndex == -1) {
      // Tampilan Default (Total Stok)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Total Stok",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12, // Dikecilkan lagi
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 2), // Spasi dikurangi
          Text(
            _formatNumber(totalValue),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16, // Dikecilkan dari 20/18
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      // Tampilan Saat Disentuh (Detail Slice)
      final touchedData = widget.data[touchedIndex];
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            touchedData.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: touchedData.color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatNumber(touchedData.value),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }

  List<PieChartSectionData> showingSections(double totalValue) {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 10.0;

      final radius = isTouched ? 65.0 : 55.0;

      final data = widget.data[i];

      final percentage = totalValue > 0 ? (data.value / totalValue) * 100 : 0;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [const Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      );
    });
  }
}
