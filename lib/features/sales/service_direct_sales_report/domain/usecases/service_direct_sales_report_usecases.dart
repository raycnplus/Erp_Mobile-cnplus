import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/data/repositories/service_direct_sales_report_repository.dart';

class GetServiceDirectSalesReportList {
  final ServiceDirectSalesReportRepository repository;

  GetServiceDirectSalesReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getServiceDirectSalesReportList(
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

class GetServiceDirectSalesReportFormOptions {
  final ServiceDirectSalesReportRepository repository;

  GetServiceDirectSalesReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}