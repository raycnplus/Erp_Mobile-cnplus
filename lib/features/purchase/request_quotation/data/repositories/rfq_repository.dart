import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/datasources/rfq_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/models/rfq_models.dart';

class RfqRepository {
  final RfqRemoteDataSource ds;
  RfqRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<RfqDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<RfqFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(RfqFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(String enc, RfqFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);
  Future<void> delete(int id) => ds.delete(id);
  Future<Map<String, dynamic>> createPO(int id) => ds.createPO(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);
  Future<List<RfqLocationOption>> getLocationsByWarehouse(int warehouseId) =>
      ds.getLocationsByWarehouse(warehouseId);
}