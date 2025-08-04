import 'package:flutter/material.dart';

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
      label: json['label'],
      value: (json['value'] as num).toDouble(),
      color: Color(int.parse(json['color'])), // pastikan format warna sesuai
    );
  }
}

class StatValue {
  final dynamic value;
  final String? label;
  final String? unit;
  final DateTime? timestamp;

  StatValue({
    required this.value,
    this.label,
    this.unit,
    this.timestamp,
  });

  factory StatValue.fromJson(Map<String, dynamic> json) {
    return StatValue(
      value: json['value'] ?? json['data'] ?? json['count'] ?? json['total'] ?? 0,
      label: json['label'],
      unit: json['unit'],
      timestamp: json['timestamp'] != null 
          ? DateTime.tryParse(json['timestamp']) 
          : null,
    );
  }
}