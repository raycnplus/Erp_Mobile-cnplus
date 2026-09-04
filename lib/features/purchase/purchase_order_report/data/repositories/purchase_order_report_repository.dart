import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/datasources/purchase_order_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/models/purchase_order_report_models.dart';

class PurchaseOrderReportRepository {
  final PurchaseOrderReportRemoteDataSource
      remoteDataSource;

  PurchaseOrderReportRepository({
    required this.remoteDataSource,
  });

  // ============================================================
  // LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getPurchaseOrderReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) {
    return remoteDataSource
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

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<PurchaseOrderReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }

  // ============================================================
  // LOCATIONS
  // ============================================================

  Future<List<PurchaseOrderLocationOption>>
      getLocationsByWarehouse(
    int idWarehouse,
  ) {
    return remoteDataSource
        .getLocationsByWarehouse(
      idWarehouse,
    );
  }
}