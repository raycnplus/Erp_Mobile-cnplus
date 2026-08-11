import 'package:erp_mobile_cnplus/features/pos/dashboard/data/repositories/pos_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';

class GetPosDashboard {
  final PosDashboardRepository _r;
  GetPosDashboard(this._r);
  Future<PosDashboardResponse> call({String? startDate, String? endDate}) =>
      _r.getDashboard(startDate: startDate, endDate: endDate);
}