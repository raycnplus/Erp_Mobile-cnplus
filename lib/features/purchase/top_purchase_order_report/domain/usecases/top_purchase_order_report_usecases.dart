import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/models/top_purchase_order_report_models.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/repositories/top_purchase_order_report_repository.dart';

class GetTopPurchaseOrderReportList {
  final TopPurchaseOrderReportRepository repository;

  GetTopPurchaseOrderReportList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    String? dateFrom,
    String? dateTo,
    int? limit,
    bool all = false,
  }) {
    return repository
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
}

class GetTopPurchaseOrderReportFormOptions {
  final TopPurchaseOrderReportRepository repository;

  GetTopPurchaseOrderReportFormOptions(
    this.repository,
  );

  Future<TopPurchaseOrderReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}