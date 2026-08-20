import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/datasources/history_stock_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';

class HistoryStockRepository {
  final HistoryStockRemoteDataSource remoteDataSource;
  HistoryStockRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getHistoryStockList({
    int page = 1,
    int perPage = 100,
    String? date,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
  }) => remoteDataSource.getHistoryStockList(
    page: page,
    perPage: perPage,
    date: date,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    idProduct: idProduct,
  );

  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
    String? date,
    String? movementType,
  }) => remoteDataSource.getTransactions(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    idProduct: idProduct,
    date: date,
    movementType: movementType,
  );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<List<HistoryLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) => remoteDataSource.getLocationsByWarehouse(idWarehouse);
}
