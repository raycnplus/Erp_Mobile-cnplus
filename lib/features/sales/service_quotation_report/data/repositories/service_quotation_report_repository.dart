import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/datasources/service_quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/models/service_quotation_report_models.dart';

class ServiceQuotationReportRepository {
  final ServiceQuotationReportRemoteDataSource remoteDataSource;

  ServiceQuotationReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getServiceQuotationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getServiceQuotationReportList(
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

  ServiceQuotationReportExportUrlInfo getExportPdfUrl({
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

  ServiceQuotationReportExportUrlInfo getExportExcelUrl({
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
}