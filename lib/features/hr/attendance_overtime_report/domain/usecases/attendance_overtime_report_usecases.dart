import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/models/attendance_overtime_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/repositories/attendance_overtime_report_repository.dart';

class GetAttendanceOvertimeReportList {
  final AttendanceOvertimeReportRepository repository;

  GetAttendanceOvertimeReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
  }) {
    return repository
        .getAttendanceOvertimeReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
    );
  }
}

class GetAttendanceOvertimeReportFormOptions {
  final AttendanceOvertimeReportRepository repository;

  GetAttendanceOvertimeReportFormOptions(
    this.repository,
  );

  Future<AttendanceOvertimeReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}