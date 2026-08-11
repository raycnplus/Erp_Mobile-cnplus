import 'package:erp_mobile_cnplus/features/sales/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/data/models/invoice_models.dart';

class InvoiceRepository {
  final InvoiceRemoteDataSource ds;

  InvoiceRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<InvoiceDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<InvoiceFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(
    InvoiceFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(
    String enc,
    InvoiceFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);

  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> createPayment(int id) => ds.createPayment(id);

  Future<double?> getPriceFromList(int productId, int priceListId) =>
      ds.getPriceFromList(productId, priceListId);

  Future<void> approve(int id) => ds.approve(id);

  Future<void> reject(int id) => ds.reject(id);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}