import 'package:erp_mobile_cnplus/features/hr/dashboard/data/datasources/hr_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';

class HrDashboardRepository {
  final HrRemoteDataSource remoteDataSource;
  HrDashboardRepository({required this.remoteDataSource});

  Future<HrDashboardData> getDashboardData({
    String? startDate,
    String? endDate,
  }) async {
    final raw = await remoteDataSource.getDashboardData(
      startDate: startDate,
      endDate: endDate,
    );
    return HrDashboardData.fromJson(raw);
  }
}