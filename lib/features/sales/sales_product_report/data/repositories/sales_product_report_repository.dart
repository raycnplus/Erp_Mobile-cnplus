import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/datasources/sales_product_report_remote_datasource.dart';

class SalesProductReportRepository {
  final SalesProductReportRemoteDataSource remoteDataSource;

  SalesProductReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getSalesProductReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idProduct,
    int? idCategory,
    String? dateFrom,
    String? dateTo,
  }) {
    return remoteDataSource.getSalesProductReportList(
      page: page,
      perPage: perPage,
      search: search,
      idProduct: idProduct,
      idCategory: idCategory,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }

  Future<Map<String, dynamic>> getFormOptions() {
    return remoteDataSource.getFormOptions();
  }
}