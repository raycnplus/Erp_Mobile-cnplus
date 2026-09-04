import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/repositories/attendance_report_repository.dart';

class GetAttendanceReportList {
  final AttendanceReportRepository repository;

  GetAttendanceReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    String? status,
  }) {
    return repository.getAttendanceReportList(
      dateFrom: dateFrom,
      dateTo: dateTo,
      employeeId: employeeId,
      departmentId: departmentId,
      status: status,
    );
  }
}

class GetAttendanceReportFormOptions {
  final AttendanceReportRepository repository;

  GetAttendanceReportFormOptions(
    this.repository,
  );

  Future<AttendanceReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}