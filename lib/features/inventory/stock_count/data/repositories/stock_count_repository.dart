import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/datasources/stock_count_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';

class StockCountRepository {
  final StockCountRemoteDataSource ds;
  StockCountRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status}) =>
      ds.getList(page: page, perPage: perPage, status: status);

  Future<StockCountDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<StockCountFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(Map<String, dynamic> payload) => ds.store(payload);
  Future<Map<String, dynamic>> update(int idStockOpname, Map<String, dynamic> payload) =>
      ds.update(idStockOpname, payload);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> storeCount({
    required int idStockOpname,
    required int idLocation,
    required List<SCFormItem> products,
    required String actionType,
  }) => ds.storeCount(idStockOpname: idStockOpname, idLocation: idLocation, products: products, actionType: actionType);

  Future<Map<String, dynamic>> loadProducts({int? warehouseId, int? locationId, int? idStockOpname}) =>
      ds.loadProducts(warehouseId: warehouseId, locationId: locationId, idStockOpname: idStockOpname);

  Future<List<SCLocationOption>> getLocationsByWarehouse(int warehouseId) => ds.getLocationsByWarehouse(warehouseId);
  Future<Map<String, dynamic>> indexLocation(String encryption, String warehouseEncryption) =>
      ds.indexLocation(encryption, warehouseEncryption);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
}