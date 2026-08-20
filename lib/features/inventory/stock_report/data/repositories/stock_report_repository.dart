import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/datasources/stock_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/models/stock_report_models.dart';

class StockReportRepository {
  final StockReportRemoteDataSource remoteDataSource;
  StockReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getStockReportList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) => remoteDataSource.getStockReportList(
    page: page,
    perPage: perPage,
    search: search,
  );

  Future<StockReportDetailModel> getStockReportDetail(int idProduct) =>
      remoteDataSource.getStockReportDetail(idProduct);
}
