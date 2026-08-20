import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/repositories/history_stock_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';

class GetHistoryStockList {
  final HistoryStockRepository repository;
  GetHistoryStockList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? date,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
  }) => repository.getHistoryStockList(
    page: page,
    perPage: perPage,
    date: date,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    idProduct: idProduct,
  );
}

class GetHistoryTransactions {
  final HistoryStockRepository repository;
  GetHistoryTransactions(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
    String? date,
    String? movementType,
  }) => repository.getTransactions(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    idProduct: idProduct,
    date: date,
    movementType: movementType,
  );
}

class GetHistoryStockFormOptions {
  final HistoryStockRepository repository;
  GetHistoryStockFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetHistoryStockLocationsByWarehouse {
  final HistoryStockRepository repository;
  GetHistoryStockLocationsByWarehouse(this.repository);

  Future<List<HistoryLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}
