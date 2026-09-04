import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/datasources/attendance_overtime_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/models/attendance_overtime_report_models.dart';

class AttendanceOvertimeReportRepository {
  final AttendanceOvertimeReportRemoteDataSource
      remoteDataSource;

  AttendanceOvertimeReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>>
      getAttendanceOvertimeReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
  }) {
    return remoteDataSource
        .getAttendanceOvertimeReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
    );
  }

  Future<AttendanceOvertimeReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}