import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/repositories/service_quotation_report_repository.dart';

class GetServiceQuotationReportList {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceQuotationReportList(
        page: page,
        perPage: perPage,
        search: search,
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetServiceQuotationReportFormOptions {
  final ServiceQuotationReportRepository repository;

  GetServiceQuotationReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}