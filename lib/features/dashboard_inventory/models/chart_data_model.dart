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

  ///stat card
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

  ///pie
  static List<ChartData> parseChartDataFromApi(dynamic apiResponse) {
    final colors = [
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFF9800), // Orange
      const Color(0xFF4CAF50), // Green
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFF44336), // Red
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFFEB3B), // Yellow
      const Color(0xFF795548), // Brown
    ];

    List<dynamic> dataList = [];

    // Handle different API response structures
    if (apiResponse is List) {
      dataList = apiResponse;
    } else if (apiResponse is Map<String, dynamic>) {
      // Check for common API wrapper patterns
      dataList =
          apiResponse['data'] ??
          apiResponse['items'] ??
          apiResponse['results'] ??
          apiResponse['chart_data'] ??
          [apiResponse]; // Single item wrapped in map
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

  ///pie - legacy method untuk backward compatibility
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

// ✅ Enhanced ChartData class
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

  // Helper method untuk format value dengan unit
  String get formattedValue {
    if (unit != null) {
      return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}$unit';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }
}
