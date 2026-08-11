import 'package:erp_mobile_cnplus/features/sales/dashboard/data/repositories/sales_dashboard_repository.dart';

class GetSalesDashboardData {
  final SalesDashboardRepository _repository;

  GetSalesDashboardData(this._repository);

  Future<Map<String, dynamic>> execute({String? startDate, String? endDate}) =>
    _repository.getDashboardData(startDate: startDate, endDate: endDate);
}