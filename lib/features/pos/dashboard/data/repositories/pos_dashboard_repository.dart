import 'package:erp_mobile_cnplus/features/pos/dashboard/data/datasources/pos_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';

class PosDashboardRepository {
  final PosRemoteDataSource _ds;
  PosDashboardRepository({required PosRemoteDataSource dataSource}) : _ds = dataSource;

  Future<PosDashboardResponse> getDashboard({String? startDate, String? endDate}) =>
      _ds.getDashboard(startDate: startDate, endDate: endDate);
}