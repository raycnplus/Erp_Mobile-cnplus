import 'package:erp_mobile_cnplus/features/hr/leave_report/data/datasources/leave_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/models/leave_report_models.dart';

class LeaveReportRepository {
  final LeaveReportRemoteDataSource remoteDataSource;

  LeaveReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getLeaveReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    int? leaveTypeId,
  }) {
    return remoteDataSource.getLeaveReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
      leaveTypeId: leaveTypeId,
    );
  }

  Future<LeaveReportFormOptions> getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}