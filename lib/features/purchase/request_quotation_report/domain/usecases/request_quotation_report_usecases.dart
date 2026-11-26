import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/repositories/request_quotation_report_repository.dart';

class GetRequestQuotationReportList {
  final RequestQuotationReportRepository repository;

  GetRequestQuotationReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) =>
      repository.getRequestQuotationReportList(
        page: page,
        perPage: perPage,
        search: search,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}

class GetRequestQuotationReportFormOptions {
  final RequestQuotationReportRepository repository;

  GetRequestQuotationReportFormOptions(this.repository);

  Future<RequestQuotationReportFormOptions> call() => repository.getFormOptions();
}

class GetRequestQuotationReportLocationsByWarehouse {
  final RequestQuotationReportRepository repository;

  GetRequestQuotationReportLocationsByWarehouse(this.repository);

  Future<List<RequestQuotationLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}

class GetRequestQuotationReportExportPdfUrl {
  final RequestQuotationReportRepository repository;

  GetRequestQuotationReportExportPdfUrl(this.repository);

  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      repository.getExportPdfUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );
}

class GetRequestQuotationReportExportExcelUrl {
  final RequestQuotationReportRepository repository;

  GetRequestQuotationReportExportExcelUrl(this.repository);

  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      repository.getExportExcelUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );
}