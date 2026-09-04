import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/datasources/attendance_late_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

class AttendanceLateReportRepository {
  final AttendanceLateReportRemoteDataSource
      remoteDataSource;

  AttendanceLateReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>>
      getAttendanceLateReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
  }) {
    return remoteDataSource
        .getAttendanceLateReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
    );
  }

  Future<AttendanceLateReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}