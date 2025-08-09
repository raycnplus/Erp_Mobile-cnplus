import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import '../models/chart_data_model.dart';
import '../../../services/api_base.dart';

class StockPieChart extends StatefulWidget {
  final List<ChartData>? data;
  final String? endpoint;
  final String? title;
  final double aspectRatio;

  const StockPieChart({
    super.key,
    this.data,
    this.endpoint,
    this.title,
    this.aspectRatio = 1.5,
  });

  @override
  State<StockPieChart> createState() => _StockPieChartState();
}

class _StockPieChartState extends State<StockPieChart> {
  int touchedIndex = -1;
  List<ChartData> chartData = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      chartData = widget.data!;
      isLoading = false;
    } else if (widget.endpoint != null) {
      fetchChartData();
    }
  }

  Future<void> fetchChartData() async {
    try {
      final url = Uri.parse('${ApiBase.baseUrl}/${widget.endpoint}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final raw = json.decode(response.body);
        final parsed = StatValue.parseChartDataFromApi(raw);
        setState(() {
          chartData = parsed;
          isLoading = false;
        });
      } else {
        throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Text("Error: $error");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: PieChart(
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
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: showingSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 70.0 : 60.0;
      final data = chartData[i];

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: '${data.value.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgeWidget: isTouched ? _buildBadge(data.label) : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}