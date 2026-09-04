class PayrollSummaryReportModel {
  final int idDepartment;
  final String department;
  final int totalEmployee;
  final double totalBasic;
  final double totalAllowance;
  final double totalOvertime;
  final double totalDeductions;
  final double totalNet;

  PayrollSummaryReportModel({
    required this.idDepartment,
    required this.department,
    required this.totalEmployee,
    required this.totalBasic,
    required this.totalAllowance,
    required this.totalOvertime,
    required this.totalDeductions,
    required this.totalNet,
  });

  factory PayrollSummaryReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PayrollSummaryReportModel(
      idDepartment:
          (json['id_department'] as num?)?.toInt() ?? 0,
      department:
          json['department']?.toString() ?? '-',
      totalEmployee:
          (json['total_employee'] as num?)?.toInt() ?? 0,
      totalBasic:
          (json['total_basic'] as num?)?.toDouble() ?? 0.0,
      totalAllowance:
          (json['total_allowance'] as num?)?.toDouble() ?? 0.0,
      totalOvertime:
          (json['total_overtime'] as num?)?.toDouble() ?? 0.0,
      totalDeductions:
          (json['total_deductions'] as num?)?.toDouble() ?? 0.0,
      totalNet:
          (json['total_net'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PayrollSummaryReportSummary {
  final int totalDepartments;
  final String totalBasic;
  final String totalAllowance;
  final String totalOvertime;
  final String totalAllowanceOvertime;
  final String totalDeductions;
  final String totalNet;

  PayrollSummaryReportSummary({
    required this.totalDepartments,
    required this.totalBasic,
    required this.totalAllowance,
    required this.totalOvertime,
    required this.totalAllowanceOvertime,
    required this.totalDeductions,
    required this.totalNet,
  });

  factory PayrollSummaryReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return PayrollSummaryReportSummary(
      totalDepartments:
          (json['total_departments'] as num?)?.toInt() ?? 0,
      totalBasic:
          json['total_basic']?.toString() ?? '0',
      totalAllowance:
          json['total_allowance']?.toString() ?? '0',
      totalOvertime:
          json['total_overtime']?.toString() ?? '0',
      totalAllowanceOvertime:
          json['total_allowance_overtime']?.toString() ?? '0',
      totalDeductions:
          json['total_deductions']?.toString() ?? '0',
      totalNet:
          json['total_net']?.toString() ?? '0',
    );
  }
}

class PayrollSummaryReportPayrollPeriodOption {
  final int idPayrollPeriod;
  final String name;
  final String? dateFrom;
  final String? dateTo;
  final String? status;

  PayrollSummaryReportPayrollPeriodOption({
    required this.idPayrollPeriod,
    required this.name,
    this.dateFrom,
    this.dateTo,
    this.status,
  });

  factory PayrollSummaryReportPayrollPeriodOption.fromJson(
    Map<String, dynamic> json,
  ) {
    final id =
        (json['id_payroll_period'] as num?)?.toInt() ?? 0;

    final dateFrom =
        json['date_from']?.toString();

    final dateTo =
        json['date_to']?.toString();

    String name = json['name']?.toString() ?? '';

    if (name.isEmpty) {
      if (dateFrom != null && dateTo != null) {
        name = '$dateFrom - $dateTo';
      } else if (dateFrom != null) {
        name = dateFrom;
      } else {
        name = 'Payroll Period #$id';
      }
    }

    return PayrollSummaryReportPayrollPeriodOption(
      idPayrollPeriod: id,
      name: name,
      dateFrom: dateFrom,
      dateTo: dateTo,
      status: json['status']?.toString(),
    );
  }
}

class PayrollSummaryReportDepartmentOption {
  final int idDepartment;
  final String departmentName;

  PayrollSummaryReportDepartmentOption({
    required this.idDepartment,
    required this.departmentName,
  });

  factory PayrollSummaryReportDepartmentOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return PayrollSummaryReportDepartmentOption(
      idDepartment:
          (json['id_department'] as num?)?.toInt() ?? 0,
      departmentName:
          json['department_name']?.toString() ?? '-',
    );
  }
}

class PayrollSummaryReportFormOptions {
  final List<PayrollSummaryReportPayrollPeriodOption>
      payrollPeriods;

  final List<PayrollSummaryReportDepartmentOption>
      departments;

  PayrollSummaryReportFormOptions({
    required this.payrollPeriods,
    required this.departments,
  });

  factory PayrollSummaryReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final payrollPeriodData =
        json['payroll_periods'] as List<dynamic>? ?? [];

    final departmentData =
        json['departments'] as List<dynamic>? ?? [];

    return PayrollSummaryReportFormOptions(
      payrollPeriods: payrollPeriodData
          .whereType<Map<String, dynamic>>()
          .map(
            (e) =>
                PayrollSummaryReportPayrollPeriodOption
                    .fromJson(e),
          )
          .toList(),
      departments: departmentData
          .whereType<Map<String, dynamic>>()
          .map(
            (e) =>
                PayrollSummaryReportDepartmentOption
                    .fromJson(e),
          )
          .toList(),
    );
  }
}