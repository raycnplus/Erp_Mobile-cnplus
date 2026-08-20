import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/datasources/stock_valuation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class StockValuationRepository {
  final StockValuationRemoteDataSource remoteDataSource;
  StockValuationRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getStockValuationList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? costingMethod,
  }) => remoteDataSource.getStockValuationList(
    page: page,
    perPage: perPage,
    search: search,
    costingMethod: costingMethod,
  );

  Future<StockValuationDetailModel> getStockValuationDetail(int idProduct) =>
      remoteDataSource.getStockValuationDetail(idProduct);

  Future<List<String>> getCostingMethods() =>
      remoteDataSource.getCostingMethods();
}
