class AttendanceLateReportSummary {
  final int totalRecords;
  final int totalLateMinutes;
  final String totalLateDisplay;

  AttendanceLateReportSummary({
    required this.totalRecords,
    required this.totalLateMinutes,
    required this.totalLateDisplay,
  });

  factory AttendanceLateReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceLateReportSummary(
      totalRecords:
          json['total_records'] ?? 0,
      totalLateMinutes:
          json['total_late_minutes'] ?? 0,
      totalLateDisplay:
          json['total_late_display'] ?? '0m',
    );
  }
}

class AttendanceLateReportModel {
  final String date;
  final String employeeName;
  final String department;
  final String scheduledIn;
  final String clockIn;
  final int lateMinutes;
  final String late;

  AttendanceLateReportModel({
    required this.date,
    required this.employeeName,
    required this.department,
    required this.scheduledIn,
    required this.clockIn,
    required this.lateMinutes,
    required this.late,
  });

  factory AttendanceLateReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceLateReportModel(
      date:
          json['date_formatted'] ??
          json['date'] ??
          '-',
      employeeName:
          json['employee_name'] ?? '-',
      department:
          json['department'] ?? '-',
      scheduledIn:
          json['scheduled_in'] ?? '-',
      clockIn:
          json['clock_in'] ?? '-',
      lateMinutes:
          json['late_minutes'] ?? 0,
      late:
          json['late'] ?? '0m',
    );
  }
}

class AttendanceLateReportEmployeeOption {
  final int idEmployee;
  final String employeeName;
  final String departmentName;

  AttendanceLateReportEmployeeOption({
    required this.idEmployee,
    required this.employeeName,
    required this.departmentName,
  });

  factory AttendanceLateReportEmployeeOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceLateReportEmployeeOption(
      idEmployee:
          json['id_employee'] ?? 0,
      employeeName:
          json['employee_name'] ?? '-',
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceLateReportDepartmentOption {
  final int idDepartment;
  final String departmentName;

  AttendanceLateReportDepartmentOption({
    required this.idDepartment,
    required this.departmentName,
  });

  factory AttendanceLateReportDepartmentOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceLateReportDepartmentOption(
      idDepartment:
          json['id_department'] ?? 0,
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceLateReportFormOptions {
  final List<AttendanceLateReportEmployeeOption>
      employees;

  final List<AttendanceLateReportDepartmentOption>
      departments;

  final String scheduledIn;

  AttendanceLateReportFormOptions({
    required this.employees,
    required this.departments,
    required this.scheduledIn,
  });

  factory AttendanceLateReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final employeeData =
        json['employees'] as List<dynamic>? ?? [];

    final departmentData =
        json['departments'] as List<dynamic>? ?? [];

    return AttendanceLateReportFormOptions(
      employees: employeeData
          .map(
            (e) =>
                AttendanceLateReportEmployeeOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      departments: departmentData
          .map(
            (e) =>
                AttendanceLateReportDepartmentOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      scheduledIn:
          json['scheduled_in'] ?? '08:00:00',
    );
  }
}