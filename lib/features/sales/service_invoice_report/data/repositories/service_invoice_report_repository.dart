import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/data/datasources/service_invoice_report_remote_datasource.dart';

class ServiceInvoiceReportRepository {
  final ServiceInvoiceReportRemoteDataSource remoteDataSource;

  ServiceInvoiceReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getServiceInvoiceReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getServiceInvoiceReportList(
        page: page,
        perPage: perPage,
        search: search,
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();
}