import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/datasources/service_direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/models/service_direct_sales_models.dart';

class ServiceDirectSalesRepository {
  final ServiceDirectSalesRemoteDataSource ds;

  ServiceDirectSalesRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ServiceDirectSalesDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<ServiceDirectSalesFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(
    ServiceDirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(
    String enc,
    ServiceDirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);

  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> createInvoiceFromTerm(int sdsId, int scheduleId) =>
      ds.createInvoiceFromTerm(sdsId, scheduleId);

  Future<double?> getPriceFromList(int serviceId, int priceListId) =>
      ds.getPriceFromList(serviceId, priceListId);
}