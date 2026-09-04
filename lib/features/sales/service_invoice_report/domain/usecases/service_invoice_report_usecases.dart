import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/data/repositories/service_invoice_report_repository.dart';

class GetServiceInvoiceReportList {
  final ServiceInvoiceReportRepository repository;

  GetServiceInvoiceReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceInvoiceReportList(
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

class GetServiceInvoiceReportFormOptions {
  final ServiceInvoiceReportRepository repository;

  GetServiceInvoiceReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}