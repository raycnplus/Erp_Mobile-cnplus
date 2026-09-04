import 'package:dio/dio.dart';

class MyPaySlipRemoteDataSource {
  final Dio dio;

  MyPaySlipRemoteDataSource(this.dio);

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>> getMyPaySlipList({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
    int? year,
  }) async {
    try {
      final response = await dio.get(
        '/hr/my-payslip',
        queryParameters: {
          'page': page,
          'per_page': perPage,

          if (search != null &&
              search.trim().isNotEmpty)
            'search': search.trim(),

          if (status != null &&
              status.trim().isNotEmpty)
            'status': status,

          if (year != null) 'year': year,
        },
      );

      return Map<String, dynamic>.from(
        response.data as Map,
      );
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // GET DETAIL
  // ============================================================

  Future<Map<String, dynamic>>
      getMyPaySlipDetail(
    String encryption,
  ) async {
    try {
      final response = await dio.get(
        '/hr/my-payslip/slip/$encryption',
      );

      return Map<String, dynamic>.from(
        response.data as Map,
      );
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // ERROR HANDLER
  // ============================================================

  String _handleDioError(
    DioException e,
  ) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            'Server error: ${e.response?.statusCode}';
      }

      return 'Server error: ${e.response?.statusCode}';
    }

    return 'Network error: ${e.message}';
  }
}