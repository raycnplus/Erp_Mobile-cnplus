import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/datasources/stock_movement_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/models/stock_movement_models.dart';

class StockMovementRepository {
  final StockMovementRemoteDataSource remoteDataSource;
  StockMovementRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getStockMovementList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) => remoteDataSource.getStockMovementList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    dateFrom: dateFrom,
    dateTo: dateTo,
  );

  Future<StockMovementFormOptions> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<List<LocationOptionModel>> getLocationsByWarehouse(int idWarehouse) =>
      remoteDataSource.getLocationsByWarehouse(idWarehouse);
}
