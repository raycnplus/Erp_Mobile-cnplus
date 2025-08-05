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
      value: json['value'] ?? json['data'] ?? json['count'] ?? json['total'] ?? 0,
      total: json['total'] ?? json['value'] ?? 0,
      label: json['label'] ?? '',
      unit: json['unit'],
      timestamp: _parseTimestamp(json['timestamp']),
    );
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

// ✅ ChartData harus di luar class lain
class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      color: _parseColor(json['color']),
    );
  }

  static Color _parseColor(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    } else if (colorValue is String) {
      try {
        return Color(int.parse(colorValue));
      } catch (_) {
        return Colors.grey;
      }
    }
    return Colors.grey;
  }
}