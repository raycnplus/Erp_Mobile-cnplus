import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/datasources/service_sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/models/service_sales_order_models.dart';

class ServiceSalesOrderRepository {
  final ServiceSalesOrderRemoteDataSource ds;

  ServiceSalesOrderRepository(this.ds);

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

  Future<ServiceSalesOrderDetailModel> getDetail(String enc) =>
      ds.getDetail(enc);

  Future<ServiceSalesOrderFormOptions> getFormOptions() =>
      ds.getFormOptions();

  Future<String> store(
    ServiceSalesOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.store(f, status, defaultTaxRate: defaultTaxRate);

  Future<String> update(
    String enc,
    ServiceSalesOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) =>
      ds.update(enc, f, status, defaultTaxRate: defaultTaxRate);

  Future<void> cancel(int id, String reason) => ds.cancel(id, reason);

  Future<void> close(int id) => ds.close(id);

  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> createInvoice(int id) =>
      ds.createInvoice(id);

  Future<Map<String, dynamic>> createInvoiceFromTerm(
    int ssoId,
    int scheduleId,
  ) =>
      ds.createInvoiceFromTerm(ssoId, scheduleId);

  Future<double?> getPriceFromList(int serviceId, int priceListId) =>
      ds.getPriceFromList(serviceId, priceListId);

  Future<void> approve(int id) => ds.approve(id);

  Future<void> reject(int id) => ds.reject(id);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}