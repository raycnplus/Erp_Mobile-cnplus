import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/models/top_purchasing_product_report_models.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/repositories/top_purchasing_product_report_repository.dart';

class GetTopPurchasingProductReportList {
  final TopPurchasingProductReportRepository
      repository;

  GetTopPurchasingProductReportList(
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
  }) {
    return repository
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
}

class GetTopPurchasingProductReportFormOptions {
  final TopPurchasingProductReportRepository
      repository;

  GetTopPurchasingProductReportFormOptions(
    this.repository,
  );

  Future<TopPurchasingProductReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}