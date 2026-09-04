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

//
// ============================================================
// PAGINATION
// ============================================================
//

class MyPaySlipPagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  MyPaySlipPagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory MyPaySlipPagination.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipPagination(
      currentPage: _parseInt(json['current_page']),
      lastPage: _parseInt(json['last_page']),
      perPage: _parseInt(json['per_page']),
      total: _parseInt(json['total']),
      from: _parseInt(json['from']),
      to: _parseInt(json['to']),
    );
  }
}

//
// ============================================================
// PAYSLIP LIST ITEM
// ============================================================
//

class MyPaySlipModel {
  final int idPayrollPeriod;
  final String encryption;
  final String periodName;

  final String dateFrom;
  final String dateTo;
  final String dateRange;

  final String status;

  final double takeHomePay;
  final String takeHomePayDisplay;

  MyPaySlipModel({
    required this.idPayrollPeriod,
    required this.encryption,
    required this.periodName,
    required this.dateFrom,
    required this.dateTo,
    required this.dateRange,
    required this.status,
    required this.takeHomePay,
    required this.takeHomePayDisplay,
  });

  factory MyPaySlipModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipModel(
      idPayrollPeriod:
          _parseInt(json['id_payroll_period']),
      encryption:
          _parseString(json['encryption']),
      periodName:
          _parseString(json['period_name']),
      dateFrom:
          _parseString(json['date_from']),
      dateTo:
          _parseString(json['date_to']),
      dateRange:
          _parseString(json['date_range']),
      status:
          _parseString(json['status']),
      takeHomePay:
          _parseDouble(json['take_home_pay']),
      takeHomePayDisplay:
          _parseString(json['take_home_pay_display']),
    );
  }
}

//
// ============================================================
// LIST RESPONSE
// ============================================================
//

class MyPaySlipResponse {
  final List<MyPaySlipModel> data;

  final MyPaySlipPagination pagination;

  MyPaySlipResponse({
    required this.data,
    required this.pagination,
  });

  factory MyPaySlipResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataList =
        json['data'] as List? ?? [];

    return MyPaySlipResponse(
      data: dataList
          .whereType<Map>()
          .map(
            (e) => MyPaySlipModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      pagination:
          MyPaySlipPagination.fromJson(
        _parseMap(json['pagination']),
      ),
    );
  }
}

//
// ============================================================
// EMPLOYEE
// ============================================================
//

class MyPaySlipEmployee {
  final int idEmployee;
  final String employeeName;
  final String departmentName;

  MyPaySlipEmployee({
    required this.idEmployee,
    required this.employeeName,
    required this.departmentName,
  });

  factory MyPaySlipEmployee.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipEmployee(
      idEmployee:
          _parseInt(json['id_employee']),
      employeeName:
          _parseString(json['employee_name']),
      departmentName:
          _parseString(json['department_name']),
    );
  }
}

//
// ============================================================
// PAYROLL PERIOD
// ============================================================
//

class MyPaySlipPeriod {
  final int idPayrollPeriod;
  final String periodName;

  final String dateFrom;
  final String dateTo;
  final String dateRange;

  final String status;

  MyPaySlipPeriod({
    required this.idPayrollPeriod,
    required this.periodName,
    required this.dateFrom,
    required this.dateTo,
    required this.dateRange,
    required this.status,
  });

  factory MyPaySlipPeriod.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipPeriod(
      idPayrollPeriod:
          _parseInt(json['id_payroll_period']),
      periodName:
          _parseString(json['period_name']),
      dateFrom:
          _parseString(json['date_from']),
      dateTo:
          _parseString(json['date_to']),
      dateRange:
          _parseString(json['date_range']),
      status:
          _parseString(json['status']),
    );
  }
}

//
// ============================================================
// PAYSLIP DETAIL
// ============================================================
//

class MyPaySlipDetail {
  final String encryption;

  final double basicSalary;
  final double totalAllowance;
  final double totalDeduction;
  final double overtime;
  final double takeHomePay;

  final String takeHomePayDisplay;

  MyPaySlipDetail({
    required this.encryption,
    required this.basicSalary,
    required this.totalAllowance,
    required this.totalDeduction,
    required this.overtime,
    required this.takeHomePay,
    required this.takeHomePayDisplay,
  });

  factory MyPaySlipDetail.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipDetail(
      encryption:
          _parseString(json['encryption']),
      basicSalary:
          _parseDouble(json['basic_salary']),
      totalAllowance:
          _parseDouble(json['total_allowance']),
      totalDeduction:
          _parseDouble(json['total_deduction']),
      overtime:
          _parseDouble(json['overtime']),
      takeHomePay:
          _parseDouble(json['take_home_pay']),
      takeHomePayDisplay:
          _parseString(json['take_home_pay_display']),
    );
  }
}

//
// ============================================================
// DETAIL RESPONSE
// ============================================================
//

class MyPaySlipDetailResponse {
  final MyPaySlipEmployee employee;
  final MyPaySlipPeriod payrollPeriod;
  final MyPaySlipDetail payslip;

  final Map<String, dynamic> detail;

  MyPaySlipDetailResponse({
    required this.employee,
    required this.payrollPeriod,
    required this.payslip,
    required this.detail,
  });

  factory MyPaySlipDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPaySlipDetailResponse(
      employee:
          MyPaySlipEmployee.fromJson(
        _parseMap(json['employee']),
      ),
      payrollPeriod:
          MyPaySlipPeriod.fromJson(
        _parseMap(json['payroll_period']),
      ),
      payslip:
          MyPaySlipDetail.fromJson(
        _parseMap(json['payslip']),
      ),
      detail:
          _parseMap(json['detail']),
    );
  }
}