import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/datasources/service_sales_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/models/service_sales_order_report_models.dart';

class ServiceSalesOrderReportRepository {
  final ServiceSalesOrderReportRemoteDataSource remoteDataSource;

  ServiceSalesOrderReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getServiceSalesOrderReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getServiceSalesOrderReportList(
        page: page,
        perPage: perPage,
        search: search,
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();

  ServiceSalesOrderReportExportUrlInfo getExportPdfUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getExportPdfUrl(
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  ServiceSalesOrderReportExportUrlInfo getExportExcelUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getExportExcelUrl(
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  ServiceSalesOrderReportExportUrlInfo getExportDetailPdfUrl(String encryption) =>
      remoteDataSource.getExportDetailPdfUrl(encryption);

  ServiceSalesOrderReportExportUrlInfo getExportDetailExcelUrl(String encryption) =>
      remoteDataSource.getExportDetailExcelUrl(encryption);
}