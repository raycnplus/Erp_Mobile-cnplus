import 'package:erp_mobile_cnplus/features/sales/quotation/data/datasources/quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/data/models/quotation_models.dart';

class QuotationRepository {
  final QuotationRemoteDataSource ds;
  QuotationRepository({required this.ds});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) => ds.getList(page: page, perPage: perPage, status: status, search: search);
  Future<QuotationDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<QuotationFormOptions> getFormOptions() => ds.getFormOptions();
  Future<String> store(QuotationFormModel f, String status, {double defaultTaxRate = 11.0}) => ds.store(f, status, defaultTaxRate: defaultTaxRate);
  Future<String> update(String enc, QuotationFormModel f, String status, {double defaultTaxRate = 11.0}) => ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);
  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);
  Future<void> delete(int id) => ds.delete(id);
  Future<Map<String, dynamic>> createSO(int id) => ds.createSO(id);
  Future<List<ProductOption>> getProductsByLocation(int locationId) => ds.getProductsByLocation(locationId);
  Future<double> checkStock(int productId, int locationId) => ds.checkStock(productId, locationId);
  Future<double?> getPriceFromList(int productId, int priceListId) => ds.getPriceFromList(productId, priceListId);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}