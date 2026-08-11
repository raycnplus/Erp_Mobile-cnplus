int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

double _parseDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

class HrTodaySummary {
  final String date;
  final int totalEmployees;
  final int checkedIn;
  final int checkedOut;
  final int onLeave;
  final int notCheckedIn;
  final int lateToday;
  final int earlyLeaveToday;
  final double attendanceRate;

  HrTodaySummary({
    required this.date,
    required this.totalEmployees,
    required this.checkedIn,
    required this.checkedOut,
    required this.onLeave,
    required this.notCheckedIn,
    required this.lateToday,
    required this.earlyLeaveToday,
    required this.attendanceRate,
  });

  factory HrTodaySummary.fromJson(Map<String, dynamic> json) {
    return HrTodaySummary(
      date: json['date']?.toString() ?? '',
      totalEmployees: _parseInt(json['total_employees']),
      checkedIn: _parseInt(json['checked_in']),
      checkedOut: _parseInt(json['checked_out']),
      onLeave: _parseInt(json['on_leave']),
      notCheckedIn: _parseInt(json['not_checked_in']),
      lateToday: _parseInt(json['late_today']),
      earlyLeaveToday: _parseInt(json['early_leave_today']),
      attendanceRate: _parseDouble(json['attendance_rate']),
    );
  }
}

class Attendance7DaysChart {
  final List<String> labels;
  final List<int> present;
  final List<int> late;

  Attendance7DaysChart({
    required this.labels,
    required this.present,
    required this.late,
  });

  factory Attendance7DaysChart.fromJson(Map<String, dynamic> json) {
    return Attendance7DaysChart(
      labels: List<String>.from(json['labels'] ?? []),
      present: List<int>.from((json['present'] ?? []).map((e) => _parseInt(e))),
      late: List<int>.from((json['late'] ?? []).map((e) => _parseInt(e))),
    );
  }
}

class HrCharts {
  final Attendance7DaysChart attendance7Days;

  HrCharts({required this.attendance7Days});

  factory HrCharts.fromJson(Map<String, dynamic> json) {
    return HrCharts(
      attendance7Days: Attendance7DaysChart.fromJson(
          json['attendance_7_days'] ?? {}),
    );
  }
}

class TopLateEmployee {
  final String name;
  final int totalLate;
  final String lateFormat;

  TopLateEmployee({
    required this.name,
    required this.totalLate,
    required this.lateFormat,
  });

  factory TopLateEmployee.fromJson(Map<String, dynamic> json) =>
      TopLateEmployee(
        name: json['name']?.toString() ?? '',
        totalLate: _parseInt(json['total_late']),
        lateFormat: json['late_format']?.toString() ?? '0m',
      );
}

class TopPresentEmployee {
  final String name;
  final int totalPresent;

  TopPresentEmployee({required this.name, required this.totalPresent});

  factory TopPresentEmployee.fromJson(Map<String, dynamic> json) =>
      TopPresentEmployee(
        name: json['name']?.toString() ?? '',
        totalPresent: _parseInt(json['total_present']),
      );
}

class HrDashboardData {
  final HrTodaySummary todaySummary;
  final HrCharts charts;
  final List<TopLateEmployee> topLateEmployees;
  final List<TopPresentEmployee> topPresentEmployees;
  final String startDate;
  final String endDate;

  HrDashboardData({
    required this.todaySummary,
    required this.charts,
    required this.topLateEmployees,
    required this.topPresentEmployees,
    required this.startDate,
    required this.endDate,
  });

  factory HrDashboardData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    return HrDashboardData(
      todaySummary:
          HrTodaySummary.fromJson(data['today_summary'] ?? {}),
      charts: HrCharts.fromJson(data['charts'] ?? {}),
      topLateEmployees: (data['top_late_employees'] as List? ?? [])
          .map((e) => TopLateEmployee.fromJson(e))
          .toList(),
      topPresentEmployees: (data['top_present_employees'] as List? ?? [])
          .map((e) => TopPresentEmployee.fromJson(e))
          .toList(),
      startDate: meta['start_date']?.toString() ?? '',
      endDate: meta['end_date']?.toString() ?? '',
    );
  }
}

typedef HrTodaySummaryAlias = HrTodaySummary;