class AttendanceOvertimeReportSummary {
  final int totalRecords;
  final int totalOvertimeMinutes;
  final String totalOvertimeDisplay;

  AttendanceOvertimeReportSummary({
    required this.totalRecords,
    required this.totalOvertimeMinutes,
    required this.totalOvertimeDisplay,
  });

  factory AttendanceOvertimeReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceOvertimeReportSummary(
      totalRecords:
          json['total_records'] ?? 0,
      totalOvertimeMinutes:
          json['total_overtime_minutes'] ?? 0,
      totalOvertimeDisplay:
          json['total_overtime_display'] ?? '0m',
    );
  }
}

class AttendanceOvertimeReportSettings {
  final String checkin;
  final String checkout;
  final double workHours;

  AttendanceOvertimeReportSettings({
    required this.checkin,
    required this.checkout,
    required this.workHours,
  });

  factory AttendanceOvertimeReportSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceOvertimeReportSettings(
      checkin:
          json['checkin'] ?? '08:00:00',
      checkout:
          json['checkout'] ?? '17:00:00',
      workHours:
          (json['work_hours'] ?? 8).toDouble(),
    );
  }
}

class AttendanceOvertimeReportModel {
  final String date;
  final String employeeName;
  final String department;
  final String clockIn;
  final String clockOut;
  final int workMinutes;
  final String workHours;
  final int overtimeMinutesRaw;
  final String overtime;

  AttendanceOvertimeReportModel({
    required this.date,
    required this.employeeName,
    required this.department,
    required this.clockIn,
    required this.clockOut,
    required this.workMinutes,
    required this.workHours,
    required this.overtimeMinutesRaw,
    required this.overtime,
  });

  factory AttendanceOvertimeReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceOvertimeReportModel(
      date: json['date_formatted']?.toString() ??
          json['date']?.toString() ??
          '-',
      employeeName:
          json['employee_name']?.toString() ?? '-',
      department:
          json['department']?.toString() ?? '-',
      clockIn:
          json['clock_in']?.toString() ?? '-',
      clockOut:
          json['clock_out']?.toString() ?? '-',
      workMinutes:
          (json['work_minutes'] as num?)?.toInt() ?? 0,
      workHours:
          json['work_hours']?.toString() ?? '0m',
      overtimeMinutesRaw:
          (json['overtime_minutes_raw'] as num?)?.toInt() ?? 0,
      overtime:
          json['overtime']?.toString() ?? '0m',
    );
  }
}

class AttendanceOvertimeReportEmployeeOption {
  final int idEmployee;
  final String employeeName;
  final String departmentName;

  AttendanceOvertimeReportEmployeeOption({
    required this.idEmployee,
    required this.employeeName,
    required this.departmentName,
  });

  factory AttendanceOvertimeReportEmployeeOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceOvertimeReportEmployeeOption(
      idEmployee:
          json['id_employee'] ?? 0,
      employeeName:
          json['employee_name'] ?? '-',
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceOvertimeReportDepartmentOption {
  final int idDepartment;
  final String departmentName;

  AttendanceOvertimeReportDepartmentOption({
    required this.idDepartment,
    required this.departmentName,
  });

  factory AttendanceOvertimeReportDepartmentOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceOvertimeReportDepartmentOption(
      idDepartment:
          json['id_department'] ?? 0,
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceOvertimeReportFormOptions {
  final List<AttendanceOvertimeReportEmployeeOption>
      employees;
  final List<AttendanceOvertimeReportDepartmentOption>
      departments;
  final AttendanceOvertimeReportSettings settings;

  AttendanceOvertimeReportFormOptions({
    required this.employees,
    required this.departments,
    required this.settings,
  });

  factory AttendanceOvertimeReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final employeeData =
        json['employees'] as List<dynamic>? ?? [];

    final departmentData =
        json['departments'] as List<dynamic>? ?? [];

    return AttendanceOvertimeReportFormOptions(
      employees: employeeData
          .map(
            (e) =>
                AttendanceOvertimeReportEmployeeOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      departments: departmentData
          .map(
            (e) =>
                AttendanceOvertimeReportDepartmentOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      settings:
          AttendanceOvertimeReportSettings.fromJson(
        json['settings']
                as Map<String, dynamic>? ??
            {},
      ),
    );
  }
}