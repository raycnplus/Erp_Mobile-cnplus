import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/datasources/invoice_report_remote_datasource.dart';

class InvoiceReportRepository {
  final InvoiceReportRemoteDataSource remoteDataSource;

  InvoiceReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getInvoiceReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? sourceType,
    int? salesPerson,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getInvoiceReportList(
        page: page,
        perPage: perPage,
        search: search,
        sourceType: sourceType,
        salesPerson: salesPerson,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();
}