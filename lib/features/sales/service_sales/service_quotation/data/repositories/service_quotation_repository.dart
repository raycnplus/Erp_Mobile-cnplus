import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/datasources/service_quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/models/service_quotation_models.dart';

class ServiceQuotationRepository {
  final ServiceQuotationRemoteDataSource ds;

  ServiceQuotationRepository(this.ds);

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

  Future<ServiceQuotationDetailModel> getDetail(String enc) =>
      ds.getDetail(enc);

  Future<ServiceQuotationFormOptions> getFormOptions() =>
      ds.getFormOptions();

  Future<String> store(
    ServiceQuotationFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(
    String enc,
    ServiceQuotationFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);

  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> createSSO(int id) => ds.createSSO(id);

  Future<double?> getPriceFromList(int serviceId, int priceListId) =>
      ds.getPriceFromList(serviceId, priceListId);

  Future<void> approve(int id) => ds.approve(id);

  Future<void> reject(int id) => ds.reject(id);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}