import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/repositories/hr_dashboard_repository.dart';

class GetHrDashboardData {
  final HrDashboardRepository repository;

  GetHrDashboardData(this.repository);

  Future<HrDashboardData> call({
    String? startDate,
    String? endDate,
  }) {
    return repository.getDashboardData(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetHrStaffDashboardData {
  final HrDashboardRepository repository;

  GetHrStaffDashboardData(this.repository);

  Future<HrDashboardData> call() {
    return repository.getStaffDashboardData();
  }
}