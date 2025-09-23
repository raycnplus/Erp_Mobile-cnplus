import 'package:flutter/material.dart';

class StatValue {
  final dynamic value;
  final dynamic total;
  final String? label;
  final String? unit;
  final DateTime? timestamp;

  StatValue({
    required this.value,
    required this.total,
    this.label,
    this.unit,
    this.timestamp,
  });

  factory StatValue.fromJson(Map<String, dynamic> json) {
    return StatValue(
      value:
          json['value'] ?? json['data'] ?? json['count'] ?? json['total'] ?? 0,
      total: json['total'] ?? json['value'] ?? 0,
      label: json['label'] ?? '',
      unit: json['unit'],
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  static List<ChartData> parseChartDataFromApi(dynamic apiResponse) {
    final colors = [
      const Color(0xFF42A5F5), // Blue 400
      const Color(0xFFFFA726), // Orange 400
      const Color(0xFF66BB6A), // Green 400
      const Color(0xFFAB47BC), // Purple 400
      const Color(0xFFEF5350), // Red 400
      const Color(0xFF26C6DA), // Cyan 400
      const Color(0xFFFFCA28), // Amber 400
      const Color(0xFF8D6E63), // Brown 400
      const Color(0xFF78909C), // Blue Grey 400
    ];

    List<dynamic> dataList = [];

    if (apiResponse is List) {
      dataList = apiResponse;
    } else if (apiResponse is Map<String, dynamic>) {
      dataList =
          apiResponse['data'] ??
          apiResponse['items'] ??
          apiResponse['results'] ??
          apiResponse['chart_data'] ??
          [apiResponse];
    }

    return List<ChartData>.generate(dataList.length, (i) {
      final item = dataList[i];

      return ChartData(
        label:
            item['label'] ??
            item['name'] ??
            item['category'] ??
            'Item ${i + 1}',
        value: (item['value'] ?? item['count'] ?? item['percentage'] ?? 0)
            .toDouble(),
        color: colors[i % colors.length],
        unit: item['unit'],
      );
    });
  }

  List<ChartData> parseChartData(dynamic json) {
    return StatValue.parseChartDataFromApi(json);
  }

  static DateTime? _parseTimestamp(dynamic ts) {
    if (ts is String) {
      return DateTime.tryParse(ts);
    } else if (ts is int) {
      return DateTime.fromMillisecondsSinceEpoch(ts);
    }
    return null;
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;
  final String? unit;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
    this.unit,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? json['name'] ?? json['category'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      color: _parseColor(json['color']),
      unit: json['unit'],
    );
  }

  static Color _parseColor(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    } else if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceAll('#', '0xFF')));
      } catch (_) {
        return Colors.grey;
      }
    }
    return Colors.grey;
  }

  // Helper untuk parsing dari struktur {labels:[], data:[]}
  static List<ChartData> fromChartMap(Map? chart, {Color? color}) {
    if (chart == null ||
        chart['labels'] == null ||
        chart['data'] == null ||
        (chart['labels'] as List).isEmpty) {
      return [];
    }
    final labels = chart['labels'] as List;
    final data = chart['data'] as List;
    final baseColor = color ?? Colors.blue;
    return List.generate(labels.length, (i) {
      final val = data[i];
      double value = 0;
      if (val is num) {
        value = val.toDouble();
      } else if (val is String) {
        value = double.tryParse(val) ?? 0;
      }
      return ChartData(
        label: labels[i].toString(),
        value: value,
        color: baseColor.withOpacity(0.7 + 0.3 * (i % 2)),
      );
    });
  }

  String get formattedValue {
    if (unit != null) {
      return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}$unit';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }
}