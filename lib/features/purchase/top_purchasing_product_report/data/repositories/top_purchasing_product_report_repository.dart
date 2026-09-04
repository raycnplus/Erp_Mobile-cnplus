import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/datasources/top_purchasing_product_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/models/top_purchasing_product_report_models.dart';

class TopPurchasingProductReportRepository {
  final TopPurchasingProductReportRemoteDataSource
      remoteDataSource;

  TopPurchasingProductReportRepository({
    required this.remoteDataSource,
  });

  // ============================================================
  // LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getTopPurchasingProductReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    String? dateFrom,
    String? dateTo,
    int? limit,
  }) {
    return remoteDataSource
        .getTopPurchasingProductReportList(
      page: page,
      perPage: perPage,
      search: search,
      idVendor: idVendor,
      dateFrom: dateFrom,
      dateTo: dateTo,
      limit: limit,
    );
  }

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<TopPurchasingProductReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}