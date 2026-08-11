import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/repositories/inventory_dashboard_repository.dart';

class GetInventoryDashboard {
  final InventoryDashboardRepository _repository;
  GetInventoryDashboard(this._repository);

  Future<Map<String, dynamic>> execute({String? startDate, String? endDate}) =>
      _repository.getDashboardData(startDate: startDate, endDate: endDate);
}