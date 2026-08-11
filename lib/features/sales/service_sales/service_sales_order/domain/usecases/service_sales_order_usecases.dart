import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/repositories/service_sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/models/service_sales_order_models.dart';

class GetSSOList {
  final ServiceSalesOrderRepository r;

  GetSSOList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(
        page: page,
        perPage: perPage,
        status: status,
        search: search,
      );
}

class GetSSODetail {
  final ServiceSalesOrderRepository r;

  GetSSODetail(this.r);

  Future<ServiceSalesOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetSSOFormOptions {
  final ServiceSalesOrderRepository r;

  GetSSOFormOptions(this.r);

  Future<ServiceSalesOrderFormOptions> call() => r.getFormOptions();
}

class SaveServiceSalesOrder {
  final ServiceSalesOrderRepository r;

  SaveServiceSalesOrder(this.r);

  Future<String> call(
    ServiceSalesOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) {
    if (f.isEditMode) {
      return r.update(
        f.encryption!,
        f,
        status,
        defaultTaxRate: defaultTaxRate,
      );
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelServiceSalesOrder {
  final ServiceSalesOrderRepository r;

  CancelServiceSalesOrder(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class CloseServiceSalesOrder {
  final ServiceSalesOrderRepository r;

  CloseServiceSalesOrder(this.r);

  Future<void> call(int id) => r.close(id);
}

class DeleteServiceSalesOrder {
  final ServiceSalesOrderRepository r;

  DeleteServiceSalesOrder(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateInvoiceFromSSO {
  final ServiceSalesOrderRepository r;

  CreateInvoiceFromSSO(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createInvoice(id);
}

class CreateInvoiceFromSSOTerm {
  final ServiceSalesOrderRepository r;

  CreateInvoiceFromSSOTerm(this.r);

  Future<Map<String, dynamic>> call(int ssoId, int scheduleId) =>
      r.createInvoiceFromTerm(ssoId, scheduleId);
}

class GetSSOPriceFromList {
  final ServiceSalesOrderRepository r;

  GetSSOPriceFromList(this.r);

  Future<double?> call(int serviceId, int priceListId) =>
      r.getPriceFromList(serviceId, priceListId);
}

class ApproveSSO {
  final ServiceSalesOrderRepository r;

  ApproveSSO(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectSSO {
  final ServiceSalesOrderRepository r;

  RejectSSO(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetSSOSteps {
  final ServiceSalesOrderRepository r;

  GetSSOSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}