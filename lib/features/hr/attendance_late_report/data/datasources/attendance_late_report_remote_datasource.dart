import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

class AttendanceLateReportRemoteDataSource {
  final Dio dio;

  AttendanceLateReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getAttendanceLateReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
  }) async {
    try {
      final response = await dio.get(
        '/hr/attendance-late-report',
        queryParameters: {
          'date_from': dateFrom,
          'date_to': dateTo,

          if (employeeId != null)
            'employee_id': employeeId,

          if (departmentId != null)
            'department_id': departmentId,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final items =
          json['data'] as List<dynamic>? ?? [];

      final models = items
          .map(
            (e) =>
                AttendanceLateReportModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      return {
        'items': models,
        'summary':
            AttendanceLateReportSummary.fromJson(
          json['summary']
                  as Map<String, dynamic>? ??
              {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<AttendanceLateReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/hr/attendance-late-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return AttendanceLateReportFormOptions
          .fromJson(
        json['data']
                as Map<String, dynamic>? ??
            {},
      );
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _handleDioError(
    DioException e,
  ) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return data['message'] ??
            'Server error: ${e.response?.statusCode}';
      }

      return 'Server error: ${e.response?.statusCode}';
    }

    return 'Network error: ${e.message}';
  }
}