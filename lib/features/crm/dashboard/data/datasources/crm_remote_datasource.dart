import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';

class CrmRemoteDataSource {
  final Dio dio;

  CrmRemoteDataSource(this.dio);

  Future<CrmDashboardResponse> getDashboard({String granularity = 'hour'}) async {
    try {
      final response = await dio.get(
        '/crm/',
        queryParameters: {'granularity': granularity},
      );
      return CrmDashboardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<CrmChartData> getConversationChart({String granularity = 'hour'}) async {
    try {
      final response = await dio.get(
        '/crm/chart/conversations',
        queryParameters: {'granularity': granularity},
      );
      final data = response.data['data'] ?? response.data;
      return CrmChartData.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<CrmChartData> getMessageChart({String granularity = 'hour'}) async {
    try {
      final response = await dio.get(
        '/crm/chart/messages',
        queryParameters: {'granularity': granularity},
      );
      final data = response.data['data'] ?? response.data;
      return CrmChartData.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? 'Network error: ${e.message}';
}