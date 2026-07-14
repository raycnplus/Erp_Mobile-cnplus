double _pd(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

int _pi(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
}

class CrmSummary {
  final int totalLeads;
  final int opportunities;
  final int customers;
  final int closedDeals;
  final double avgResponseTime;
  final double avgErrorRate;

  const CrmSummary({
    required this.totalLeads,
    required this.opportunities,
    required this.customers,
    required this.closedDeals,
    required this.avgResponseTime,
    required this.avgErrorRate,
  });

  factory CrmSummary.fromJson(Map<String, dynamic> json) {
    return CrmSummary(
      totalLeads: _pi(json['total_leads']),
      opportunities: _pi(json['opportunities']),
      customers: _pi(json['customers']),
      closedDeals: _pi(json['closed_deals']),
      avgResponseTime: _pd(json['avg_response_time']),
      avgErrorRate: _pd(json['avg_error_rate']),
    );
  }
}

class CrmChartData {
  final List<String> labels;
  final List<int> values;

  const CrmChartData({
    required this.labels,
    required this.values,
  });

  factory CrmChartData.fromJson(Map<String, dynamic> json) {
    return CrmChartData(
      labels: (json['labels'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      values: (json['values'] as List? ?? [])
          .map(_pi)
          .toList(),
    );
  }

  bool get isEmpty => labels.isEmpty;
}

class CrmDashboardResponse {
  final CrmSummary summary;
  final CrmChartData conversationChart;
  final CrmChartData messageChart;

  const CrmDashboardResponse({
    required this.summary,
    required this.conversationChart,
    required this.messageChart,
  });

  factory CrmDashboardResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return CrmDashboardResponse(
      summary: CrmSummary.fromJson(data),
      conversationChart: CrmChartData.fromJson(
        data['conversation_chart'] ?? {},
      ),
      messageChart: CrmChartData.fromJson(
        data['message_chart'] ?? {},
      ),
    );
  }
}

enum CrmGranularity {
  hour,
  day,
  week,
  month,
  year,
}

extension CrmGranularityExt on CrmGranularity {
  String get value => name;

  String get label {
    switch (this) {
      case CrmGranularity.hour:
        return 'Hourly';

      case CrmGranularity.day:
        return 'Daily';

      case CrmGranularity.week:
        return 'Weekly';

      case CrmGranularity.month:
        return 'Monthly';

      case CrmGranularity.year:
        return 'Yearly';
    }
  }
}