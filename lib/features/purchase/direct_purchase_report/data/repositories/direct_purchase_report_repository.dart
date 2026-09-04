import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/datasources/direct_purchase_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/models/direct_purchase_report_models.dart';

class DirectPurchaseReportRepository {
  final DirectPurchaseReportRemoteDataSource
      remoteDataSource;

  DirectPurchaseReportRepository({
    required this.remoteDataSource,
  });

  // ============================================================
  // LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getDirectPurchaseReportList({
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
        .getDirectPurchaseReportList(
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

  Future<DirectPurchaseReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }

  // ============================================================
  // LOCATIONS
  // ============================================================

  Future<List<DirectPurchaseLocationOption>>
      getLocationsByWarehouse(
    int idWarehouse,
  ) {
    return remoteDataSource
        .getLocationsByWarehouse(
      idWarehouse,
    );
  }
}