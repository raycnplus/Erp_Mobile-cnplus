import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/datasources/direct_sales_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/models/direct_sales_report_models.dart';

class DirectSalesReportRepository {
  final DirectSalesReportRemoteDataSource remoteDataSource;

  DirectSalesReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getDirectSalesReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getDirectSalesReportList(
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

  Future<List<DirectSalesLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) => remoteDataSource.getLocationsByWarehouse(idWarehouse);
}