import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/datasources/inventory_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';

class InventoryDashboardRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  InventoryDashboardRepository({
    required InventoryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  Future<Map<String, dynamic>> getDashboardData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final raw = await _remoteDataSource.getDashboardData(
        startDate: startDate,
        endDate: endDate,
      );

      return {
        'success': true,
        'data': InventoryDashboardData.fromJson(raw),
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Silakan coba lagi.';

      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return 'Sesi berakhir. Silakan login ulang.';
        }

        if (e.response?.statusCode == 500) {
          return 'Terjadi kesalahan pada server.';
        }

        return 'Error: ${e.response?.statusCode}';

      case DioExceptionType.unknown:
        return 'Tidak ada koneksi internet.';

      default:
        return 'Terjadi kesalahan.';
    }
  }
}