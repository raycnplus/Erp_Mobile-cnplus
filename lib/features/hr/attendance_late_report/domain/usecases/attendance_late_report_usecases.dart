import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/repositories/attendance_late_report_repository.dart';

class GetAttendanceLateReportList {
  final AttendanceLateReportRepository repository;

  GetAttendanceLateReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
  }) {
    return repository
        .getAttendanceLateReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
    );
  }
}

class GetAttendanceLateReportFormOptions {
  final AttendanceLateReportRepository repository;

  GetAttendanceLateReportFormOptions(
    this.repository,
  );

  Future<AttendanceLateReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}