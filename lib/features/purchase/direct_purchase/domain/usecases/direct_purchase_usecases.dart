import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/repositories/direct_purchase_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';

class GetDirectPurchaseList {
  final DirectPurchaseRepository r;

  GetDirectPurchaseList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetDirectPurchaseDetail {
  final DirectPurchaseRepository r;

  GetDirectPurchaseDetail(this.r);

  Future<DirectPurchaseDetailModel> call(String enc) => r.getDetail(enc);
}

class GetDirectPurchaseFormOptions {
  final DirectPurchaseRepository r;

  GetDirectPurchaseFormOptions(this.r);

  Future<DirectPurchaseFormOptions> call() => r.getFormOptions();
}

class SaveDirectPurchase {
  final DirectPurchaseRepository r;

  SaveDirectPurchase(this.r);

  Future<String> call(DirectPurchaseFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelDirectPurchase {
  final DirectPurchaseRepository r;

  CancelDirectPurchase(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class CloseDirectPurchase {
  final DirectPurchaseRepository r;

  CloseDirectPurchase(this.r);

  Future<void> call(int id) => r.close(id);
}

class DeleteDirectPurchase {
  final DirectPurchaseRepository r;

  DeleteDirectPurchase(this.r);

  Future<void> call(int id) => r.delete(id);
}

class GetDirectPurchaseSteps {
  final DirectPurchaseRepository r;

  GetDirectPurchaseSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveDirectPurchase {
  final DirectPurchaseRepository r;

  ApproveDirectPurchase(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectDirectPurchase {
  final DirectPurchaseRepository r;

  RejectDirectPurchase(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetDirectPurchasePriceFromList {
  final DirectPurchaseRepository r;

  GetDirectPurchasePriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}