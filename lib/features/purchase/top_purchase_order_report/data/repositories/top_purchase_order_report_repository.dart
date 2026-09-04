import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/datasources/top_purchase_order_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/models/top_purchase_order_report_models.dart';

class TopPurchaseOrderReportRepository {
  final TopPurchaseOrderReportRemoteDataSource
      remoteDataSource;

  TopPurchaseOrderReportRepository({
    required this.remoteDataSource,
  });

  // ============================================================
  // LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getTopPurchaseOrderReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    String? dateFrom,
    String? dateTo,
    int? limit,
    bool all = false,
  }) {
    return remoteDataSource
        .getTopPurchaseOrderReportList(
      page: page,
      perPage: perPage,
      search: search,
      idVendor: idVendor,
      dateFrom: dateFrom,
      dateTo: dateTo,
      limit: limit,
      all: all,
    );
  }

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<TopPurchaseOrderReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}