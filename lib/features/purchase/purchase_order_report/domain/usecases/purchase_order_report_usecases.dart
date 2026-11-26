import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/models/purchase_order_report_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/repositories/purchase_order_report_repository.dart';

class GetPurchaseOrderReportList {
  final PurchaseOrderReportRepository
      repository;

  GetPurchaseOrderReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) {
    return repository
        .getPurchaseOrderReportList(
      page: page,
      perPage: perPage,
      search: search,
      idVendor: idVendor,
      idWarehouse: idWarehouse,
      idLocation: idLocation,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}

class GetPurchaseOrderReportFormOptions {
  final PurchaseOrderReportRepository
      repository;

  GetPurchaseOrderReportFormOptions(
    this.repository,
  );

  Future<PurchaseOrderReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}

class GetPurchaseOrderReportLocationsByWarehouse {
  final PurchaseOrderReportRepository
      repository;

  GetPurchaseOrderReportLocationsByWarehouse(
    this.repository,
  );

  Future<List<PurchaseOrderLocationOption>>
      call(
    int idWarehouse,
  ) {
    return repository
        .getLocationsByWarehouse(
      idWarehouse,
    );
  }
}

class GetPurchaseOrderReportExportPdfUrl {
  final PurchaseOrderReportRepository repository;

  GetPurchaseOrderReportExportPdfUrl(this.repository);

  PurchaseOrderReportExportUrlInfo call({
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) =>
      repository.getExportPdfUrl(
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}

class GetPurchaseOrderReportExportExcelUrl {
  final PurchaseOrderReportRepository repository;

  GetPurchaseOrderReportExportExcelUrl(this.repository);

  PurchaseOrderReportExportUrlInfo call({
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) =>
      repository.getExportExcelUrl(
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}