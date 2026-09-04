import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/models/leave_report_models.dart';

class LeaveReportRemoteDataSource {
  final Dio dio;

  LeaveReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>> getLeaveReportList({
    required String dateFrom,
    required String dateTo,
    int? employeeId,
    int? departmentId,
    int? leaveTypeId,
  }) async {
    try {
      final response = await dio.get(
        '/hr/leave-report',
        queryParameters: {
          'date_from': dateFrom,
          'date_to': dateTo,

          if (employeeId != null)
            'employee_id': employeeId,

          if (departmentId != null)
            'department_id': departmentId,

          if (leaveTypeId != null)
            'leave_type_id': leaveTypeId,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final items =
          json['data'] as List<dynamic>? ?? [];

      final models = items
          .map(
            (e) => LeaveReportModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      return {
        'items': models,
        'summary':
            LeaveReportSummary.fromJson(
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

  Future<LeaveReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/hr/leave-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return LeaveReportFormOptions.fromJson(
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