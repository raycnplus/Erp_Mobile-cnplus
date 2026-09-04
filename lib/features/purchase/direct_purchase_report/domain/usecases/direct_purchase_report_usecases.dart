import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/models/direct_purchase_report_models.dart';

import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/repositories/direct_purchase_report_repository.dart';

class GetDirectPurchaseReportList {
  final DirectPurchaseReportRepository
      repository;

  GetDirectPurchaseReportList(
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
}

class GetDirectPurchaseReportFormOptions {
  final DirectPurchaseReportRepository
      repository;

  GetDirectPurchaseReportFormOptions(
    this.repository,
  );

  Future<DirectPurchaseReportFormOptions>
      call() {
    return repository.getFormOptions();
  }
}

class GetDirectPurchaseReportLocationsByWarehouse {
  final DirectPurchaseReportRepository
      repository;

  GetDirectPurchaseReportLocationsByWarehouse(
    this.repository,
  );

  Future<List<DirectPurchaseLocationOption>>
      call(
    int idWarehouse,
  ) {
    return repository
        .getLocationsByWarehouse(
      idWarehouse,
    );
  }
}