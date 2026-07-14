import 'package:erp_mobile_cnplus/features/crm/dashboard/data/datasources/crm_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';

class CrmDashboardRepository {
  final CrmRemoteDataSource _ds;
  CrmDashboardRepository({required CrmRemoteDataSource dataSource}) : _ds = dataSource;

  Future<CrmDashboardResponse> getDashboard({String granularity = 'hour'}) => _ds.getDashboard(granularity: granularity);
  Future<CrmChartData> getConversationChart({String granularity = 'hour'}) => _ds.getConversationChart(granularity: granularity);
  Future<CrmChartData> getMessageChart({String granularity = 'hour'}) => _ds.getMessageChart(granularity: granularity);
}