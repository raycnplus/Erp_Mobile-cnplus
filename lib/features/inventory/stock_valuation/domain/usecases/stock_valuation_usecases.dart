import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/repositories/stock_valuation_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class GetStockValuationWarehouseList {
  final StockValuationRepository repository;
  GetStockValuationWarehouseList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    String? branch,
  }) => repository.getWarehouseList(page: page, perPage: perPage, search: search, branch: branch);
}

class GetStockValuationWarehouseDetail {
  final StockValuationRepository repository;
  GetStockValuationWarehouseDetail(this.repository);

  Future<StockValuationDetailModel> call(
    int idWarehouse, {
    int page = 1,
    int perPage = 100,
    String? search,
  }) => repository.getWarehouseDetail(idWarehouse, page: page, perPage: perPage, search: search);
}

class GetStockValuationBranches {
  final StockValuationRepository repository;
  GetStockValuationBranches(this.repository);

  Future<List<String>> call() => repository.getBranches();
}