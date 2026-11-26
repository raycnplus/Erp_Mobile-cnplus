import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/datasources/request_quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';

class RequestQuotationReportRepository {
  final RequestQuotationReportRemoteDataSource remoteDataSource;

  RequestQuotationReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getRequestQuotationReportList({
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
      remoteDataSource.getRequestQuotationReportList(
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

  Future<RequestQuotationReportFormOptions> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<List<RequestQuotationLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) =>
      remoteDataSource.getLocationsByWarehouse(idWarehouse);

  ExportUrlInfo getExportPdfUrl({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      remoteDataSource.getExportPdfUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );

  ExportUrlInfo getExportExcelUrl({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      remoteDataSource.getExportExcelUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );
}