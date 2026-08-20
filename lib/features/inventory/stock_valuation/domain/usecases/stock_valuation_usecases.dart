import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/repositories/stock_valuation_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class GetStockValuationList {
  final StockValuationRepository repository;
  GetStockValuationList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    String? costingMethod,
  }) => repository.getStockValuationList(
    page: page,
    perPage: perPage,
    search: search,
    costingMethod: costingMethod,
  );
}

class GetStockValuationDetail {
  final StockValuationRepository repository;
  GetStockValuationDetail(this.repository);

  Future<StockValuationDetailModel> call(int idProduct) =>
      repository.getStockValuationDetail(idProduct);
}

class GetStockValuationCostingMethods {
  final StockValuationRepository repository;
  GetStockValuationCostingMethods(this.repository);

  Future<List<String>> call() => repository.getCostingMethods();
}
