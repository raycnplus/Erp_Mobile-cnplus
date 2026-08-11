import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/datasources/direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/models/direct_sales_models.dart';

class DirectSalesRepository {
  final DirectSalesRemoteDataSource ds;

  DirectSalesRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      ds.getList(
        page: page,
        perPage: perPage,
        status: status,
        search: search,
      );

  Future<DirectSalesDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<DirectSalesFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(
    DirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(
    String enc,
    DirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);

  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> createInvoice(int id) =>
      ds.createInvoice(id);

  Future<Map<String, dynamic>> createInvoiceFromTerm(
    int dsId,
    int scheduleId,
  ) =>
      ds.createInvoiceFromTerm(dsId, scheduleId);

  Future<List<DSProductOption>> getProductsByLocation(int locationId) =>
      ds.getProductsByLocation(locationId);

  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);

  Future<void> approve(int id) => ds.approve(id);

  Future<void> reject(int id) => ds.reject(id);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}