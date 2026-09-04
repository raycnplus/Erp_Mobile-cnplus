import 'package:dio/dio.dart';

class HrRemoteDataSource {
  final Dio dio;

  HrRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getDashboardData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await dio.get(
        '/hr/',
        queryParameters: {
          if (startDate != null)
            'start_date': startDate,
          if (endDate != null)
            'end_date': endDate,
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

  Future<Map<String, dynamic>>
      getStaffDashboardData() async {
    try {
      final response = await dio.get(
        '/hr/staff',
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