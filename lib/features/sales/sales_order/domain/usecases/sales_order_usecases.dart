import 'package:erp_mobile_cnplus/features/sales/sales_order/data/repositories/sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/models/sales_order_models.dart';

class GetSOList {
  final SalesOrderRepository r;

  GetSOList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetSODetail {
  final SalesOrderRepository r;

  GetSODetail(this.r);

  Future<SalesOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetSOFormOptions {
  final SalesOrderRepository r;

  GetSOFormOptions(this.r);

  Future<SalesOrderFormOptions> call() => r.getFormOptions();
}

class SaveSalesOrder {
  final SalesOrderRepository r;

  SaveSalesOrder(this.r);

  Future<String> call(SalesOrderFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelSalesOrder {
  final SalesOrderRepository r;

  CancelSalesOrder(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class CloseSalesOrder {
  final SalesOrderRepository r;

  CloseSalesOrder(this.r);

  Future<void> call(int id) => r.close(id);
}

class DeleteSalesOrder {
  final SalesOrderRepository r;

  DeleteSalesOrder(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateInvoiceFromSO {
  final SalesOrderRepository r;

  CreateInvoiceFromSO(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createInvoice(id);
}

class CreateInvoiceFromTerm {
  final SalesOrderRepository r;

  CreateInvoiceFromTerm(this.r);

  Future<Map<String, dynamic>> call(int soId, int scheduleId) =>
      r.createInvoiceFromTerm(soId, scheduleId);
}

class GetSOProductsByLocation {
  final SalesOrderRepository r;

  GetSOProductsByLocation(this.r);

  Future<List<SOProductOption>> call(int locationId) => r.getProductsByLocation(locationId);
}

class GetSOPriceFromList {
  final SalesOrderRepository r;

  GetSOPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApproveSalesOrder {
  final SalesOrderRepository r;

  ApproveSalesOrder(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectSalesOrder {
  final SalesOrderRepository r;

  RejectSalesOrder(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetSOSteps {
  final SalesOrderRepository r;

  GetSOSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}