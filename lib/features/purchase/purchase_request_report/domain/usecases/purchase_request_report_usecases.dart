import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/repositories/purchase_request_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/models/purchase_request_report_models.dart';

class GetPurchaseRequestReportList {
  final PurchaseRequestReportRepository repository;
  GetPurchaseRequestReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) =>
      repository.getPurchaseRequestReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}

class GetPurchaseRequestReportFormOptions {
  final PurchaseRequestReportRepository repository;
  GetPurchaseRequestReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetPurchaseRequestReportLocationsByWarehouse {
  final PurchaseRequestReportRepository repository;
  GetPurchaseRequestReportLocationsByWarehouse(this.repository);

  Future<List<PurchaseRequestLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}

class GetPurchaseRequestReportExportPdfUrl {
  final PurchaseRequestReportRepository repository;
  GetPurchaseRequestReportExportPdfUrl(this.repository);

  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
  }) =>
      repository.getExportPdfUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
      );
}

class GetPurchaseRequestReportExportExcelUrl {
  final PurchaseRequestReportRepository repository;
  GetPurchaseRequestReportExportExcelUrl(this.repository);

  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
  }) =>
      repository.getExportExcelUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
      );
}