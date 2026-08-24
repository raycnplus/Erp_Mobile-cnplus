import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/datasources/stock_valuation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class StockValuationRepository {
  final StockValuationRemoteDataSource remoteDataSource;
  StockValuationRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getWarehouseList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? branch,
  }) => remoteDataSource.getWarehouseList(page: page, perPage: perPage, search: search, branch: branch);

  Future<StockValuationDetailModel> getWarehouseDetail(
    int idWarehouse, {
    int page = 1,
    int perPage = 100,
    String? search,
  }) => remoteDataSource.getWarehouseDetail(idWarehouse, page: page, perPage: perPage, search: search);

  Future<List<String>> getBranches() => remoteDataSource.getBranches();
}