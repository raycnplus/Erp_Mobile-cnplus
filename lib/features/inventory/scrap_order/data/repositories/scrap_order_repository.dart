import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/datasources/scrap_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/models/scrap_order_models.dart';

class ScrapOrderRepository {
  final ScrapOrderRemoteDataSource ds;
  ScrapOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ScrapOrderDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<ScrapOrderFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(ScrapOrderFormModel f, String status) => ds.store(f, status);
  Future<Map<String, dynamic>> update(String encryption, ScrapOrderFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<List<Map<String, dynamic>>> getProductsByLocation(int locationId) => ds.getProductsByLocation(locationId);
  Future<double> checkStock(int productId, int locationId) => ds.checkStock(productId, locationId);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
}