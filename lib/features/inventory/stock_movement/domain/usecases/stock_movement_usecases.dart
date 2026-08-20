import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/repositories/stock_movement_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/models/stock_movement_models.dart';

class GetStockMovementList {
  final StockMovementRepository repository;
  GetStockMovementList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) => repository.getStockMovementList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    dateFrom: dateFrom,
    dateTo: dateTo,
  );
}

class GetStockMovementFormOptions {
  final StockMovementRepository repository;
  GetStockMovementFormOptions(this.repository);

  Future<StockMovementFormOptions> call() => repository.getFormOptions();
}

class GetStockMovementLocationsByWarehouse {
  final StockMovementRepository repository;
  GetStockMovementLocationsByWarehouse(this.repository);

  Future<List<LocationOptionModel>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}
