import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/data/datasources/service_direct_sales_report_remote_datasource.dart';

class ServiceDirectSalesReportRepository {
  final ServiceDirectSalesReportRemoteDataSource remoteDataSource;

  ServiceDirectSalesReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getServiceDirectSalesReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getServiceDirectSalesReportList(
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