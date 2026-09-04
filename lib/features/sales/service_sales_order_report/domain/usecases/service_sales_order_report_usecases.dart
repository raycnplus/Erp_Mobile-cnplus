import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/repositories/service_sales_order_report_repository.dart';

class GetServiceSalesOrderReportList {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceSalesOrderReportList(
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

class GetServiceSalesOrderReportFormOptions {
  final ServiceSalesOrderReportRepository repository;

  GetServiceSalesOrderReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}