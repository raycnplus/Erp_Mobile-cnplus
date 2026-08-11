import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/datasources/direct_purchase_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';

class DirectPurchaseRepository {
  final DirectPurchaseRemoteDataSource ds;
  DirectPurchaseRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<DirectPurchaseDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<DirectPurchaseFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(DirectPurchaseFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(String enc, DirectPurchaseFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);
  Future<void> close(int id) => ds.close(id);
  Future<void> delete(int id) => ds.delete(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);
}