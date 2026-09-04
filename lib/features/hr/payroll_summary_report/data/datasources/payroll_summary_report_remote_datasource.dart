import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

class PayrollSummaryReportRemoteDataSource {
  final Dio dio;

  PayrollSummaryReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getPayrollSummaryReportList({
    required int payrollPeriodId,
    int? departmentId,
  }) async {
    try {
      final response = await dio.get(
        '/hr/payroll-summary-report',
        queryParameters: {
          'payroll_period_id':
              payrollPeriodId,

          if (departmentId != null)
            'department_id':
                departmentId,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final items =
          json['data'] as List<dynamic>? ?? [];

      final models = items
          .map(
            (e) =>
                PayrollSummaryReportModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      return {
        'items': models,

        'summary':
            PayrollSummaryReportSummary.fromJson(
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

  Future<PayrollSummaryReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/hr/payroll-summary-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return PayrollSummaryReportFormOptions
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