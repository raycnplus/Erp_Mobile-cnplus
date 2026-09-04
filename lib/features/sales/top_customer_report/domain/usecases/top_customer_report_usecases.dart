import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/repositories/top_customer_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/models/top_customer_report_models.dart';

class GetTopCustomerReportList {
  final TopCustomerReportRepository repository;
  GetTopCustomerReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) => repository.getTopCustomerReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}

class GetTopCustomerReportFormOptions {
  final TopCustomerReportRepository repository;
  GetTopCustomerReportFormOptions(this.repository);

  Future<List<TopCustomerWarehouseOption>> call() => repository.getFormOptions();
}

class GetTopCustomerReportLocationsByWarehouse {
  final TopCustomerReportRepository repository;
  GetTopCustomerReportLocationsByWarehouse(this.repository);

  Future<List<TopCustomerLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}