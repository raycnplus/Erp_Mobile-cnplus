import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/repositories/stock_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/models/stock_report_models.dart';

class GetStockReportList {
  final StockReportRepository repository;
  GetStockReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
  }) => repository.getStockReportList(
    page: page,
    perPage: perPage,
    search: search,
  );
}

class GetStockReportDetail {
  final StockReportRepository repository;
  GetStockReportDetail(this.repository);

  Future<StockReportDetailModel> call(int idProduct) =>
      repository.getStockReportDetail(idProduct);
}
