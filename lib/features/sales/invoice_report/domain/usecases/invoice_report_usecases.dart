import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/repositories/invoice_report_repository.dart';

class GetInvoiceReportList {
  final InvoiceReportRepository repository;

  GetInvoiceReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    String? sourceType,
    int? salesPerson,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getInvoiceReportList(
        page: page,
        perPage: perPage,
        search: search,
        sourceType: sourceType,
        salesPerson: salesPerson,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetInvoiceReportFormOptions {
  final InvoiceReportRepository repository;

  GetInvoiceReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}