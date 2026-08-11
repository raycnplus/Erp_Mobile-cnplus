import 'package:erp_mobile_cnplus/features/hr/dashboard/data/repositories/hr_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';

class GetHrDashboardData {
  final HrDashboardRepository repository;
  GetHrDashboardData(this.repository);

  Future<HrDashboardData> call({
    String? startDate,
    String? endDate,
  }) =>
      repository.getDashboardData(
        startDate: startDate,
        endDate: endDate,
      );
}