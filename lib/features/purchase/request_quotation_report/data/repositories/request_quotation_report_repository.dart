import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/datasources/request_quotation_report_remote_datasource.dart';

import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';

class RequestQuotationReportRepository {
  final RequestQuotationReportRemoteDataSource
      remoteDataSource;

  RequestQuotationReportRepository({
    required this.remoteDataSource,
  });

  // ============================================================
  // LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getRequestQuotationReportList({
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
        .getRequestQuotationReportList(
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

  Future<RequestQuotationReportFormOptions>
      getFormOptions() {
    return remoteDataSource.getFormOptions();
  }

  // ============================================================
  // LOCATIONS
  // ============================================================

  Future<List<RequestQuotationLocationOption>>
      getLocationsByWarehouse(
    int idWarehouse,
  ) {
    return remoteDataSource
        .getLocationsByWarehouse(
      idWarehouse,
    );
  }
}