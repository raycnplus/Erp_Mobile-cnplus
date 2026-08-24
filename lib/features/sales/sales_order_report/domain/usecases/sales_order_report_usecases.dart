import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/repositories/sales_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/models/sales_order_report_models.dart';

class GetSalesOrderReportList {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getSalesOrderReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetSalesOrderReportFormOptions {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetSalesOrderReportLocationsByWarehouse {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportLocationsByWarehouse(this.repository);

  Future<List<SalesOrderLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}