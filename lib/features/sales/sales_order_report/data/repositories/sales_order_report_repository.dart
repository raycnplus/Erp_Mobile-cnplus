import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/datasources/sales_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/models/sales_order_report_models.dart';

class SalesOrderReportRepository {
  final SalesOrderReportRemoteDataSource remoteDataSource;

  SalesOrderReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getSalesOrderReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getSalesOrderReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<List<SalesOrderLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) => remoteDataSource.getLocationsByWarehouse(idWarehouse);
}