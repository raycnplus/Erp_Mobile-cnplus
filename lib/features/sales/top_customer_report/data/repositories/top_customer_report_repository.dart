import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/datasources/top_customer_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/models/top_customer_report_models.dart';

class TopCustomerReportRepository {
  final TopCustomerReportRemoteDataSource remoteDataSource;
  TopCustomerReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getTopCustomerReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) => remoteDataSource.getTopCustomerReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

  Future<List<TopCustomerWarehouseOption>> getFormOptions() => remoteDataSource.getFormOptions();

  Future<List<TopCustomerLocationOption>> getLocationsByWarehouse(int idWarehouse) =>
      remoteDataSource.getLocationsByWarehouse(idWarehouse);
}