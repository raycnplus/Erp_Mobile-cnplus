

class SalesChartData {
  final String label;
  final double value;

  SalesChartData({required this.label, required this.value});

  factory SalesChartData.fromJson(Map<String, dynamic> json) {
    return SalesChartData(
      label: json['label'] ?? '',
      value: double.tryParse(json['value'].toString()) ?? 0,
    );
  }
}