import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/repositories/manufacturing_dashboard_repository.dart';

class GetManufacturingDashboardData {
  final ManufacturingDashboardRepository _repository;
  GetManufacturingDashboardData(this._repository);
  Future<Map<String, dynamic>> execute({String? startDate, String? endDate}) =>
      _repository.getDashboardData(startDate: startDate, endDate: endDate);
}