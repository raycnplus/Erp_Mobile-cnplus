import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';

class PosRemoteDataSource {
  final Dio dio;
  PosRemoteDataSource(this.dio);

  Future<PosDashboardResponse> getDashboard({String? startDate, String? endDate}) async {
    try {
      final response = await dio.get('/pos/', queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      });
      return PosDashboardResponse.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data?['message'] ?? 'Network error: ${e.message}';
}