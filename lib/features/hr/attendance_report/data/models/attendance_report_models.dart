class AttendanceReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  AttendanceReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory AttendanceReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class AttendanceReportSummary {
  final int totalRecords;
  final Map<String, int> byStatus;

  AttendanceReportSummary({
    required this.totalRecords,
    required this.byStatus,
  });

  factory AttendanceReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawStatus =
        json['by_status'] as Map<String, dynamic>? ?? {};

    final Map<String, int> status = {};

    rawStatus.forEach((key, value) {
      status[key] = value is int
          ? value
          : int.tryParse(value.toString()) ?? 0;
    });

    return AttendanceReportSummary(
      totalRecords:
          json['total_records'] ?? 0,
      byStatus: status,
    );
  }
}

class AttendanceReportModel {
  final String employeeName;
  final String department;
  final String date;
  final String clockIn;
  final String clockOut;
  final double workingHoursDecimal;
  final String workingHours;
  final int lateMinutes;
  final String late;
  final int overtimeMinutes;
  final String ot;
  final String statusRaw;
  final String status;

  AttendanceReportModel({
    required this.employeeName,
    required this.department,
    required this.date,
    required this.clockIn,
    required this.clockOut,
    required this.workingHoursDecimal,
    required this.workingHours,
    required this.lateMinutes,
    required this.late,
    required this.overtimeMinutes,
    required this.ot,
    required this.statusRaw,
    required this.status,
  });

  factory AttendanceReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceReportModel(
      employeeName:
          json['employee_name'] ?? '-',
      department:
          json['department'] ?? '-',
      date:
          json['date_formatted'] ??
          json['date'] ??
          '-',
      clockIn:
          json['clock_in'] ?? '-',
      clockOut:
          json['clock_out'] ?? '-',
      workingHoursDecimal:
          (json['working_hours_decimal'] ?? 0)
              .toDouble(),
      workingHours:
          json['working_hours'] ?? '0h',
      lateMinutes:
          json['late_minutes'] ?? 0,
      late:
          json['late'] ?? '0m',
      overtimeMinutes:
          json['overtime_minutes'] ?? 0,
      ot:
          json['ot'] ?? '0m',
      statusRaw:
          json['status_raw'] ?? '-',
      status:
          json['status'] ?? '-',
    );
  }
}

class AttendanceReportEmployeeOption {
  final int idEmployee;
  final String employeeName;
  final String departmentName;

  AttendanceReportEmployeeOption({
    required this.idEmployee,
    required this.employeeName,
    required this.departmentName,
  });

  factory AttendanceReportEmployeeOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceReportEmployeeOption(
      idEmployee:
          json['id_employee'] ?? 0,
      employeeName:
          json['employee_name'] ?? '-',
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceReportDepartmentOption {
  final int idDepartment;
  final String departmentName;

  AttendanceReportDepartmentOption({
    required this.idDepartment,
    required this.departmentName,
  });

  factory AttendanceReportDepartmentOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceReportDepartmentOption(
      idDepartment:
          json['id_department'] ?? 0,
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class AttendanceReportFormOptions {
  final List<AttendanceReportEmployeeOption>
      employees;
  final List<AttendanceReportDepartmentOption>
      departments;
  final List<String> statuses;

  AttendanceReportFormOptions({
    required this.employees,
    required this.departments,
    required this.statuses,
  });

  factory AttendanceReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final employeeData =
        json['employees'] as List<dynamic>? ?? [];

    final departmentData =
        json['departments'] as List<dynamic>? ?? [];

    final statusData =
        json['statuses'] as List<dynamic>? ?? [];

    return AttendanceReportFormOptions(
      employees: employeeData
          .map(
            (e) =>
                AttendanceReportEmployeeOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      departments: departmentData
          .map(
            (e) =>
                AttendanceReportDepartmentOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      statuses: statusData
          .map((e) => e.toString())
          .toList(),
    );
  }
}