int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;

  if (value is num) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0;
}

String _parseString(dynamic value) {
  return value?.toString() ?? '';
}

Map<String, dynamic> _parseMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return {};
}

List<Map<String, dynamic>> _parseList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

//
// ============================================================
// ROOT DASHBOARD
// ============================================================
//

class HrDashboardData {
  final String dashboardType;
  final Map<String, dynamic> meta;

  final HrAdminDashboardData? admin;
  final HrStaffDashboardData? staff;

  HrDashboardData({
    required this.dashboardType,
    required this.meta,
    this.admin,
    this.staff,
  });

  bool get isAdmin => dashboardType == 'admin';

  bool get isStaff => dashboardType == 'staff';

  factory HrDashboardData.fromJson(Map<String, dynamic> json) {
    final dashboardType =
        _parseString(json['dashboard_type']).toLowerCase();

    final meta = _parseMap(json['meta']);

    final data = _parseMap(json['data']);

    if (dashboardType == 'admin') {
      return HrDashboardData(
        dashboardType: 'admin',
        meta: meta,
        admin: HrAdminDashboardData.fromJson(data, meta),
      );
    }

    return HrDashboardData(
      dashboardType: 'staff',
      meta: meta,
      staff: HrStaffDashboardData.fromJson(data, meta),
    );
  }
}

//
// ============================================================
// ADMIN
// ============================================================
//

class HrAdminDashboardData {
  final HrTodaySummary todaySummary;

  final HrCharts charts;

  final List<TopLateEmployee> topLateEmployees;

  final List<TopPresentEmployee> topPresentEmployees;

  final String startDate;

  final String endDate;

  HrAdminDashboardData({
    required this.todaySummary,
    required this.charts,
    required this.topLateEmployees,
    required this.topPresentEmployees,
    required this.startDate,
    required this.endDate,
  });

  factory HrAdminDashboardData.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
  ) {
    return HrAdminDashboardData(
      todaySummary: HrTodaySummary.fromJson(
        _parseMap(json['today_summary']),
      ),
      charts: HrCharts.fromJson(
        _parseMap(json['charts']),
      ),
      topLateEmployees: _parseList(json['top_late_employees'])
          .map(TopLateEmployee.fromJson)
          .toList(),
      topPresentEmployees: _parseList(json['top_present_employees'])
          .map(TopPresentEmployee.fromJson)
          .toList(),
      startDate: _parseString(meta['start_date']),
      endDate: _parseString(meta['end_date']),
    );
  }
}

//
// ============================================================
// ADMIN TODAY SUMMARY
// ============================================================
//

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
      date: _parseString(json['date']),
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

//
// ============================================================
// ADMIN CHART
// ============================================================
//

class Attendance7DaysChart {
  final List<String> labels;
  final List<int> present;
  final List<int> late;

  Attendance7DaysChart({
    required this.labels,
    required this.present,
    required this.late,
  });

  factory Attendance7DaysChart.fromJson(
    Map<String, dynamic> json,
  ) {
    return Attendance7DaysChart(
      labels: List<String>.from(
        json['labels'] ?? [],
      ),
      present: (json['present'] as List? ?? [])
          .map(_parseInt)
          .toList(),
      late: (json['late'] as List? ?? [])
          .map(_parseInt)
          .toList(),
    );
  }
}

class HrCharts {
  final Attendance7DaysChart attendance7Days;

  HrCharts({
    required this.attendance7Days,
  });

  factory HrCharts.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrCharts(
      attendance7Days: Attendance7DaysChart.fromJson(
        _parseMap(json['attendance_7_days']),
      ),
    );
  }
}

//
// ============================================================
// TOP EMPLOYEE
// ============================================================
//

class TopLateEmployee {
  final String name;
  final int totalLate;
  final String lateFormat;

  TopLateEmployee({
    required this.name,
    required this.totalLate,
    required this.lateFormat,
  });

  factory TopLateEmployee.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopLateEmployee(
      name: _parseString(json['name']),
      totalLate: _parseInt(json['total_late']),
      lateFormat: _parseString(json['late_format']),
    );
  }
}

class TopPresentEmployee {
  final String name;
  final int totalPresent;

  TopPresentEmployee({
    required this.name,
    required this.totalPresent,
  });

  factory TopPresentEmployee.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPresentEmployee(
      name: _parseString(json['name']),
      totalPresent: _parseInt(json['total_present']),
    );
  }
}

//
// ============================================================
// STAFF EMPLOYEE
// ============================================================
//

class HrStaffDashboardData {
  final HrStaffEmployee employee;

  final HrStaffTodayAttendance todayAttendance;

  final HrStaffMonthlyStats monthlyStats;

  final HrStaffLeave leave;

  final HrStaffOvertime overtime;

  final HrStaffPayslip? latestPayslip;

  final List<HrRecentAttendance> recentAttendance;

  final HrStaffCharts charts;

  final String today;

  final String monthStart;

  final String monthEnd;

  final int employeeId;

  final int userId;

  HrStaffDashboardData({
    required this.employee,
    required this.todayAttendance,
    required this.monthlyStats,
    required this.leave,
    required this.overtime,
    required this.latestPayslip,
    required this.recentAttendance,
    required this.charts,
    required this.today,
    required this.monthStart,
    required this.monthEnd,
    required this.employeeId,
    required this.userId,
  });

  factory HrStaffDashboardData.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
  ) {
    return HrStaffDashboardData(
      employee: HrStaffEmployee.fromJson(
        _parseMap(json['employee']),
      ),
      todayAttendance: HrStaffTodayAttendance.fromJson(
        _parseMap(json['today_attendance']),
      ),
      monthlyStats: HrStaffMonthlyStats.fromJson(
        _parseMap(json['monthly_stats']),
      ),
      leave: HrStaffLeave.fromJson(
        _parseMap(json['leave']),
      ),
      overtime: HrStaffOvertime.fromJson(
        _parseMap(json['overtime']),
      ),
      latestPayslip: json['latest_payslip'] == null
          ? null
          : HrStaffPayslip.fromJson(
              _parseMap(json['latest_payslip']),
            ),
      recentAttendance: _parseList(json['recent_attendance'])
          .map(HrRecentAttendance.fromJson)
          .toList(),
      charts: HrStaffCharts.fromJson(
        _parseMap(json['charts']),
      ),
      today: _parseString(meta['today']),
      monthStart: _parseString(meta['month_start']),
      monthEnd: _parseString(meta['month_end']),
      employeeId: _parseInt(meta['employee_id']),
      userId: _parseInt(meta['user_id']),
    );
  }
}

//
// ============================================================
// STAFF EMPLOYEE INFO
// ============================================================
//

class HrStaffEmployee {
  final int id;
  final String name;
  final String employeeCode;
  final String department;
  final String position;

  HrStaffEmployee({
    required this.id,
    required this.name,
    required this.employeeCode,
    required this.department,
    required this.position,
  });

  factory HrStaffEmployee.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffEmployee(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      employeeCode: _parseString(
        json['employee_code'],
      ),
      department: _parseString(
        json['department'],
      ),
      position: _parseString(
        json['position'],
      ),
    );
  }
}

//
// ============================================================
// STAFF TODAY
// ============================================================
//

class HrStaffTodayAttendance {
  final bool checkedIn;
  final bool checkedOut;

  final String checkInTime;
  final String checkOutTime;

  final int lateMinutes;
  final int earlyLeaveMinutes;

  final String status;

  HrStaffTodayAttendance({
    required this.checkedIn,
    required this.checkedOut,
    required this.checkInTime,
    required this.checkOutTime,
    required this.lateMinutes,
    required this.earlyLeaveMinutes,
    required this.status,
  });

  factory HrStaffTodayAttendance.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffTodayAttendance(
      checkedIn: json['checked_in'] == true,
      checkedOut: json['checked_out'] == true,
      checkInTime: _parseString(
        json['check_in_time'],
      ),
      checkOutTime: _parseString(
        json['check_out_time'],
      ),
      lateMinutes: _parseInt(
        json['late_minutes'],
      ),
      earlyLeaveMinutes: _parseInt(
        json['early_leave_minutes'],
      ),
      status: _parseString(
        json['status'],
      ),
    );
  }
}

//
// ============================================================
// STAFF MONTHLY
// ============================================================
//

class HrStaffMonthlyStats {
  final int totalWorkingDays;
  final int presentDays;
  final int lateDays;
  final int leaveDays;
  final int absentDays;

  HrStaffMonthlyStats({
    required this.totalWorkingDays,
    required this.presentDays,
    required this.lateDays,
    required this.leaveDays,
    required this.absentDays,
  });

  factory HrStaffMonthlyStats.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffMonthlyStats(
      totalWorkingDays: _parseInt(
        json['total_working_days'],
      ),
      presentDays: _parseInt(
        json['present_days'],
      ),
      lateDays: _parseInt(
        json['late_days'],
      ),
      leaveDays: _parseInt(
        json['leave_days'],
      ),
      absentDays: _parseInt(
        json['absent_days'],
      ),
    );
  }
}

//
// ============================================================
// STAFF LEAVE
// ============================================================
//

class HrStaffLeave {
  final double totalQuota;
  final double used;
  final double remaining;

  HrStaffLeave({
    required this.totalQuota,
    required this.used,
    required this.remaining,
  });

  factory HrStaffLeave.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffLeave(
      totalQuota: _parseDouble(
        json['total_quota'],
      ),
      used: _parseDouble(
        json['used'],
      ),
      remaining: _parseDouble(
        json['remaining'],
      ),
    );
  }
}

//
// ============================================================
// STAFF OVERTIME
// ============================================================
//

class HrStaffOvertime {
  final double thisMonth;
  final String thisMonthDisplay;

  HrStaffOvertime({
    required this.thisMonth,
    required this.thisMonthDisplay,
  });

  factory HrStaffOvertime.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffOvertime(
      thisMonth: _parseDouble(
        json['this_month'],
      ),
      thisMonthDisplay: _parseString(
        json['this_month_display'],
      ),
    );
  }
}

//
// ============================================================
// STAFF PAYSLIP
// ============================================================
//

class HrStaffPayslip {
  final dynamic encryption;

  final double takeHomePay;

  final String periodName;

  HrStaffPayslip({
    required this.encryption,
    required this.takeHomePay,
    required this.periodName,
  });

  factory HrStaffPayslip.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffPayslip(
      encryption: json['encryption'],
      takeHomePay: _parseDouble(
        json['take_home_pay'],
      ),
      periodName: _parseString(
        json['period_name'],
      ),
    );
  }
}

//
// ============================================================
// STAFF RECENT ATTENDANCE
// ============================================================
//

class HrRecentAttendance {
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;
  final int lateMinutes;

  HrRecentAttendance({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.lateMinutes,
  });

  factory HrRecentAttendance.fromJson(Map<String, dynamic> json) {
    return HrRecentAttendance(
      date: _parseString(json['attendance_date']),
      checkIn: _parseString(json['check_in_time']),
      checkOut: _parseString(json['check_out_time']),
      status: _parseString(json['status']),
      lateMinutes: _parseInt(json['late_minutes']),
    );
  }
}

//
// ============================================================
// STAFF CHART
// ============================================================
//

class HrStaffCharts {
  final AttendanceLate14DaysChart attendanceLate14Days;

  HrStaffCharts({
    required this.attendanceLate14Days,
  });

  factory HrStaffCharts.fromJson(
    Map<String, dynamic> json,
  ) {
    return HrStaffCharts(
      attendanceLate14Days:
          AttendanceLate14DaysChart.fromJson(
        _parseMap(
          json['attendance_late_14_days'],
        ),
      ),
    );
  }
}

class AttendanceLate14DaysChart {
  final List<String> labels;
  final List<int> lateMinutes;

  AttendanceLate14DaysChart({
    required this.labels,
    required this.lateMinutes,
  });

  factory AttendanceLate14DaysChart.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceLate14DaysChart(
      labels: List<String>.from(
        json['labels'] ?? [],
      ),
      lateMinutes: (json['late_minutes'] as List? ?? [])
          .map(_parseInt)
          .toList(),
    );
  }
}