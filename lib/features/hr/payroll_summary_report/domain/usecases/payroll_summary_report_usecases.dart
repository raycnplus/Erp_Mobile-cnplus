import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/repositories/payroll_summary_report_repository.dart';

class GetPayrollSummaryReportList {
  final PayrollSummaryReportRepository repository;

  GetPayrollSummaryReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    required int payrollPeriodId,
    int? departmentId,
  }) {
    return repository
        .getPayrollSummaryReportList(
      payrollPeriodId:
          payrollPeriodId,
      departmentId:
          departmentId,
    );
  }
}

class GetPayrollSummaryReportFormOptions {
  final PayrollSummaryReportRepository repository;

  GetPayrollSummaryReportFormOptions(
    this.repository,
  );

  Future<PayrollSummaryReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}