import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/models/general_dashboard_models.dart';

class GeneralDashboardRemoteDataSource {
  final Dio dio;
  GeneralDashboardRemoteDataSource(this.dio);

  Future<GeneralDashboardModel> getDashboard({String? startDate, String? endDate}) async {
    try {
      final r = await dio.get('/general-dashboard', queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate   != null) 'end_date':   endDate,
      });
      return GeneralDashboardModel.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load dashboard');
    }
  }
}