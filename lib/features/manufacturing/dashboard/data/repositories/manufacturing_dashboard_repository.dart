import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/datasources/manufacturing_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/models/manufacturing_dashboard_models.dart';

class ManufacturingDashboardRepository {
  final ManufacturingRemoteDataSource _remoteDataSource;
  ManufacturingDashboardRepository({required ManufacturingRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Future<Map<String, dynamic>> getDashboardData({String? startDate, String? endDate}) async {
    try {
      final raw = await _remoteDataSource.getDashboardData(startDate: startDate, endDate: endDate);
      return {'success': true, 'data': ManufacturingDashboardResponse.fromJson(raw)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleDioError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout: return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) return 'Session expired. Please login again.';
        if (e.response?.statusCode == 500) return 'Internal server error.';
        return 'Error: ${e.response?.statusCode}';
      case DioExceptionType.unknown: return 'No internet connection.';
      default: return 'An error occurred.';
    }
  }
}