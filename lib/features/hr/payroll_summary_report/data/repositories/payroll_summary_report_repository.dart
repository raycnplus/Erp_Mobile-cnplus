import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/datasources/payroll_summary_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

class PayrollSummaryReportRepository {
  final PayrollSummaryReportRemoteDataSource
      remoteDataSource;

  PayrollSummaryReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>>
      getPayrollSummaryReportList({
    required int payrollPeriodId,
    int? departmentId,
  }) {
    return remoteDataSource
        .getPayrollSummaryReportList(
      payrollPeriodId:
          payrollPeriodId,
      departmentId:
          departmentId,
    );
  }

  Future<PayrollSummaryReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}