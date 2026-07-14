import 'package:erp_mobile_cnplus/features/general_dashboard/data/repositories/general_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/models/general_dashboard_models.dart';

class GetGeneralDashboard {
  final GeneralDashboardRepository repository;
  GetGeneralDashboard(this.repository);
  Future<GeneralDashboardModel> call({String? startDate, String? endDate}) =>
      repository.getDashboard(startDate: startDate, endDate: endDate);
}