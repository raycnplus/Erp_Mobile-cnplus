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
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}