import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/repositories/service_sales_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/models/service_sales_order_report_models.dart';

class GetServiceSalesOrderReportList {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceSalesOrderReportList(
        page: page,
        perPage: perPage,
        search: search,
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetServiceSalesOrderReportFormOptions {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetServiceSalesOrderReportExportPdfUrl {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportExportPdfUrl(this.repository);

  ServiceSalesOrderReportExportUrlInfo call({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportPdfUrl(
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetServiceSalesOrderReportExportExcelUrl {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportExportExcelUrl(this.repository);

  ServiceSalesOrderReportExportUrlInfo call({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportExcelUrl(
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetServiceSalesOrderReportExportDetailPdfUrl {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportExportDetailPdfUrl(this.repository);

  ServiceSalesOrderReportExportUrlInfo call(String encryption) =>
      repository.getExportDetailPdfUrl(encryption);
}

class GetServiceSalesOrderReportExportDetailExcelUrl {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportExportDetailExcelUrl(this.repository);

  ServiceSalesOrderReportExportUrlInfo call(String encryption) =>
      repository.getExportDetailExcelUrl(encryption);
}