import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/datasources/attendance_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';

class AttendanceReportRepository {
  final AttendanceReportRemoteDataSource
      remoteDataSource;

  AttendanceReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>>
      getAttendanceReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    String? status,
  }) {
    return remoteDataSource
        .getAttendanceReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
      status: status,
    );
  }

  Future<AttendanceReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}