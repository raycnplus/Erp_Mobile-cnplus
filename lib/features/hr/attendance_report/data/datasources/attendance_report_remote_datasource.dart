import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';

class AttendanceReportRemoteDataSource {
  final Dio dio;

  AttendanceReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>> getAttendanceReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        '/hr/attendance-report',
        queryParameters: {
          'date_from': dateFrom,
          'date_to': dateTo,

          if (employeeId != null)
            'employee_id': employeeId,

          if (departmentId != null)
            'department_id': departmentId,

          if (status != null &&
              status.isNotEmpty)
            'status': status,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final items =
          json['data'] as List<dynamic>? ?? [];

      final models = items
          .map(
            (e) =>
                AttendanceReportModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      return {
        'items': models,

        'meta':
            AttendanceReportPaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: models.length,
          total: models.length,
        ),

        'summary':
            AttendanceReportSummary.fromJson(
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

  Future<AttendanceReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/hr/attendance-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return AttendanceReportFormOptions.fromJson(
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