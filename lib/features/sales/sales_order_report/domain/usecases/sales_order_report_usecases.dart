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

class GetSalesOrderReportExportPdfUrl {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportExportPdfUrl(this.repository);

  SalesOrderReportExportUrlInfo call({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportPdfUrl(
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetSalesOrderReportExportExcelUrl {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportExportExcelUrl(this.repository);

  SalesOrderReportExportUrlInfo call({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportExcelUrl(
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetSalesOrderReportExportDetailPdfUrl {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportExportDetailPdfUrl(this.repository);

  SalesOrderReportExportUrlInfo call(String encryption) =>
      repository.getExportDetailPdfUrl(encryption);
}

class GetSalesOrderReportExportDetailExcelUrl {
  final SalesOrderReportRepository repository;

  GetSalesOrderReportExportDetailExcelUrl(this.repository);

  SalesOrderReportExportUrlInfo call(String encryption) =>
      repository.getExportDetailExcelUrl(encryption);
}