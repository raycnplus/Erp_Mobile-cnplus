import 'package:erp_mobile_cnplus/features/crm/dashboard/data/repositories/crm_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';

class GetCrmDashboard {
  final CrmDashboardRepository _r;
  GetCrmDashboard(this._r);
  Future<CrmDashboardResponse> call({String granularity = 'hour'}) => _r.getDashboard(granularity: granularity);
}

class GetCrmConversationChart {
  final CrmDashboardRepository _r;
  GetCrmConversationChart(this._r);
  Future<CrmChartData> call({String granularity = 'hour'}) => _r.getConversationChart(granularity: granularity);
}

class GetCrmMessageChart {
  final CrmDashboardRepository _r;
  GetCrmMessageChart(this._r);
  Future<CrmChartData> call({String granularity = 'hour'}) => _r.getMessageChart(granularity: granularity);
}