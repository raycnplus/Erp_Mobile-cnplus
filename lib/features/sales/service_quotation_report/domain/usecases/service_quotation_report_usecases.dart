import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/repositories/service_quotation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/models/service_quotation_report_models.dart';

class GetServiceQuotationReportList {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceQuotationReportList(
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

class GetServiceQuotationReportFormOptions {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetServiceQuotationReportExportPdfUrl {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportExportPdfUrl(this.repository);

  ServiceQuotationReportExportUrlInfo call({
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

class GetServiceQuotationReportExportExcelUrl {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportExportExcelUrl(this.repository);

  ServiceQuotationReportExportUrlInfo call({
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