import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/repositories/accounting_remote_repositories.dart';

class GetAccountingDashboardData {
  final AccountingDashboardRepository _repository;
  GetAccountingDashboardData(this._repository);

  Future<Map<String, dynamic>> execute({String? startDate, String? endDate}) =>
      _repository.getDashboardData(startDate: startDate, endDate: endDate);
}