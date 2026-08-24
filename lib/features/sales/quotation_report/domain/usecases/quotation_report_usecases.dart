import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/repositories/quotation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/models/quotation_report_models.dart';

class GetQuotationReportList {
  final QuotationReportRepository repository;
  GetQuotationReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getQuotationReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetQuotationReportFormOptions {
  final QuotationReportRepository repository;
  GetQuotationReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetQuotationReportLocationsByWarehouse {
  final QuotationReportRepository repository;
  GetQuotationReportLocationsByWarehouse(this.repository);

  Future<List<QuotationLocationOption>> call(int idWarehouse) => repository.getLocationsByWarehouse(idWarehouse);
}