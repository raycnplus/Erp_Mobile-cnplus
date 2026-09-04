class LeaveReportSummary {
  final int totalRecords;
  final int grandTotalRequest;
  final double grandTotalDays;

  LeaveReportSummary({
    required this.totalRecords,
    required this.grandTotalRequest,
    required this.grandTotalDays,
  });

  factory LeaveReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveReportSummary(
      totalRecords:
          json['total_records'] ?? 0,
      grandTotalRequest:
          json['grand_total_request'] ?? 0,
      grandTotalDays:
          (json['grand_total_days'] ?? 0).toDouble(),
    );
  }
}

class LeaveReportModel {
  final int idEmployee;
  final String employeeName;
  final String department;
  final int? idLeaveType;
  final String leaveTypeName;
  final int totalRequest;
  final double totalDays;

  LeaveReportModel({
    required this.idEmployee,
    required this.employeeName,
    required this.department,
    required this.idLeaveType,
    required this.leaveTypeName,
    required this.totalRequest,
    required this.totalDays,
  });

  factory LeaveReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveReportModel(
      idEmployee:
          json['id_employee'] ?? 0,
      employeeName:
          json['employee_name'] ?? '-',
      department:
          json['department'] ?? '-',
      idLeaveType:
          json['id_leave_type'],
      leaveTypeName:
          json['leave_type_name'] ?? '-',
      totalRequest:
          json['total_request'] ?? 0,
      totalDays:
          (json['total_days'] ?? 0).toDouble(),
    );
  }
}

class LeaveReportEmployeeOption {
  final int idEmployee;
  final String employeeName;
  final String departmentName;

  LeaveReportEmployeeOption({
    required this.idEmployee,
    required this.employeeName,
    required this.departmentName,
  });

  factory LeaveReportEmployeeOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveReportEmployeeOption(
      idEmployee:
          json['id_employee'] ?? 0,
      employeeName:
          json['employee_name'] ?? '-',
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class LeaveReportDepartmentOption {
  final int idDepartment;
  final String departmentName;

  LeaveReportDepartmentOption({
    required this.idDepartment,
    required this.departmentName,
  });

  factory LeaveReportDepartmentOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveReportDepartmentOption(
      idDepartment:
          json['id_department'] ?? 0,
      departmentName:
          json['department_name'] ?? '-',
    );
  }
}

class LeaveReportLeaveTypeOption {
  final int idLeaveType;
  final String leaveTypeName;

  LeaveReportLeaveTypeOption({
    required this.idLeaveType,
    required this.leaveTypeName,
  });

  factory LeaveReportLeaveTypeOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveReportLeaveTypeOption(
      idLeaveType:
          json['id_leave_type'] ?? 0,
      leaveTypeName:
          json['leave_type_name'] ?? '-',
    );
  }
}

class LeaveReportFormOptions {
  final List<LeaveReportEmployeeOption> employees;
  final List<LeaveReportDepartmentOption> departments;
  final List<LeaveReportLeaveTypeOption> leaveTypes;

  LeaveReportFormOptions({
    required this.employees,
    required this.departments,
    required this.leaveTypes,
  });

  factory LeaveReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final employeeData =
        json['employees'] as List<dynamic>? ?? [];

    final departmentData =
        json['departments'] as List<dynamic>? ?? [];

    final leaveTypeData =
        json['leave_types'] as List<dynamic>? ?? [];

    return LeaveReportFormOptions(
      employees: employeeData
          .map(
            (e) => LeaveReportEmployeeOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      departments: departmentData
          .map(
            (e) => LeaveReportDepartmentOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      leaveTypes: leaveTypeData
          .map(
            (e) => LeaveReportLeaveTypeOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}