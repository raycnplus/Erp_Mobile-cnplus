import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/datasources/purchase_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';

class PurchaseOrderRepository {
  final PurchaseOrderRemoteDataSource ds;
  PurchaseOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<PurchaseOrderDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<PurchaseOrderFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(PurchaseOrderFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(String enc, PurchaseOrderFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);
  Future<void> close(int id) => ds.close(id);
  Future<void> delete(int id) => ds.delete(id);
  Future<Map<String, dynamic>> createBillFromPurchaseOrder(int id) => ds.createBillFromPurchaseOrder(id);
  Future<Map<String, dynamic>> createBillFromTerm(int poId, int scheduleId) =>
      ds.createBillFromTerm(poId, scheduleId);
  Future<double> getLastPrices(int idVendor, int idProduct) => ds.getLastPrices(idVendor, idProduct);
  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}