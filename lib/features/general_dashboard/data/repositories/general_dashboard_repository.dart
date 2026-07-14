import 'package:erp_mobile_cnplus/features/general_dashboard/data/datasources/general_dashboard_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/models/general_dashboard_models.dart';

class GeneralDashboardRepository {
  final GeneralDashboardRemoteDataSource remoteDataSource;
  GeneralDashboardRepository({required this.remoteDataSource});
  Future<GeneralDashboardModel> getDashboard({String? startDate, String? endDate}) =>
      remoteDataSource.getDashboard(startDate: startDate, endDate: endDate);
}