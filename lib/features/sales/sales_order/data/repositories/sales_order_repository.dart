import 'package:erp_mobile_cnplus/features/sales/sales_order/data/datasources/sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/models/sales_order_models.dart';

class SalesOrderRepository {
  final SalesOrderRemoteDataSource ds;
  SalesOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<SalesOrderDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<SalesOrderFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(SalesOrderFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(String enc, SalesOrderFormModel f, String status, {double defaultTaxRate = 11.0}) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);
  Future<void> close(int id) => ds.close(id);
  Future<void> delete(int id) => ds.delete(id);
  Future<Map<String, dynamic>> createInvoice(int id) => ds.createInvoice(id);
  Future<Map<String, dynamic>> createInvoiceFromTerm(int soId, int scheduleId) =>
      ds.createInvoiceFromTerm(soId, scheduleId);
  Future<List<SOProductOption>> getProductsByLocation(int locationId) =>
      ds.getProductsByLocation(locationId);
  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}