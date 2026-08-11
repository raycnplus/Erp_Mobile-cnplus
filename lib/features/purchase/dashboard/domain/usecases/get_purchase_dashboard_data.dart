import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/repositories/purchase_remote_repositories.dart';

class GetPurchaseDashboardData {
  final PurchaseDashboardRepository _repository;
  GetPurchaseDashboardData(this._repository);

  Future<Map<String, dynamic>> execute({String? startDate, String? endDate}) =>
      _repository.getDashboardData(startDate: startDate, endDate: endDate);
}