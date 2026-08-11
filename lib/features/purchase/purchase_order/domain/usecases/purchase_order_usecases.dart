import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/repositories/purchase_order_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';

class GetPOList {
  final PurchaseOrderRepository r;

  GetPOList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetPODetail {
  final PurchaseOrderRepository r;

  GetPODetail(this.r);

  Future<PurchaseOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetPOFormOptions {
  final PurchaseOrderRepository r;

  GetPOFormOptions(this.r);

  Future<PurchaseOrderFormOptions> call() => r.getFormOptions();
}

class SavePurchaseOrder {
  final PurchaseOrderRepository r;

  SavePurchaseOrder(this.r);

  Future<String> call(PurchaseOrderFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelPurchaseOrder {
  final PurchaseOrderRepository r;

  CancelPurchaseOrder(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class ClosePurchaseOrder {
  final PurchaseOrderRepository r;

  ClosePurchaseOrder(this.r);

  Future<void> call(int id) => r.close(id);
}

class DeletePurchaseOrder {
  final PurchaseOrderRepository r;

  DeletePurchaseOrder(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateBillFromPO {
  final PurchaseOrderRepository r;

  CreateBillFromPO(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createBillFromPurchaseOrder(id);
}

class CreateBillFromTerm {
  final PurchaseOrderRepository r;

  CreateBillFromTerm(this.r);

  Future<Map<String, dynamic>> call(int poId, int scheduleId) =>
      r.createBillFromTerm(poId, scheduleId);
}

class GetPOLastPrices {
  final PurchaseOrderRepository r;

  GetPOLastPrices(this.r);

  Future<double> call(int idVendor, int idProduct) => r.getLastPrices(idVendor, idProduct);
}

class GetPOPriceFromList {
  final PurchaseOrderRepository r;

  GetPOPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApprovePurchaseOrder {
  final PurchaseOrderRepository r;

  ApprovePurchaseOrder(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectPurchaseOrder {
  final PurchaseOrderRepository r;

  RejectPurchaseOrder(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetPOSteps {
  final PurchaseOrderRepository r;

  GetPOSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}