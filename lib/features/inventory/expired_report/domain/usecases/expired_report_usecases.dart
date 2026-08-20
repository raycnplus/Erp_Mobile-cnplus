import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/repositories/expired_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/models/expired_report_models.dart';

class GetExpiredReportList {
  final ExpiredReportRepository repository;
  GetExpiredReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? expiryStatus,
  }) => repository.getExpiredReportList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    dateFrom: dateFrom,
    dateTo: dateTo,
    expiryStatus: expiryStatus,
  );
}

class GetExpiredReportFormOptions {
  final ExpiredReportRepository repository;
  GetExpiredReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetExpiredReportLocationsByWarehouse {
  final ExpiredReportRepository repository;
  GetExpiredReportLocationsByWarehouse(this.repository);

  Future<List<ExpiredLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}
