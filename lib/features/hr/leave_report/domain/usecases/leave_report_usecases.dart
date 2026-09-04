import 'package:erp_mobile_cnplus/features/hr/leave_report/data/models/leave_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/repositories/leave_report_repository.dart';

class GetLeaveReportList {
  final LeaveReportRepository repository;

  GetLeaveReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    int? leaveTypeId,
  }) {
    return repository.getLeaveReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
      leaveTypeId: leaveTypeId,
    );
  }
}

class GetLeaveReportFormOptions {
  final LeaveReportRepository repository;

  GetLeaveReportFormOptions(
    this.repository,
  );

  Future<LeaveReportFormOptions> call() {
    return repository.getFormOptions();
  }
}