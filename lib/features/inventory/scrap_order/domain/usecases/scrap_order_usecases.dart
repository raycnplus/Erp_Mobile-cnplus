import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/repositories/scrap_order_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/models/scrap_order_models.dart';

class GetScrapOrderList {
  final ScrapOrderRepository r;
  GetScrapOrderList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetScrapOrderDetail {
  final ScrapOrderRepository r;
  GetScrapOrderDetail(this.r);

  Future<ScrapOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetScrapOrderFormOptions {
  final ScrapOrderRepository r;
  GetScrapOrderFormOptions(this.r);

  Future<ScrapOrderFormOptions> call() => r.getFormOptions();
}

class SaveScrapOrder {
  final ScrapOrderRepository r;
  SaveScrapOrder(this.r);

  Future<Map<String, dynamic>> call(ScrapOrderFormModel f) {
    if (f.isEditMode && f.encryption != null) {
      return r.update(f.encryption!, f, 'save');
    }
    return r.store(f, 'save');
  }
}

class ConfirmScrapOrder {
  final ScrapOrderRepository r;
  ConfirmScrapOrder(this.r);

  Future<Map<String, dynamic>> call(ScrapOrderFormModel f) {
    if (f.encryption == null) throw Exception('Scrap Order must be saved before confirming');
    return r.update(f.encryption!, f, 'confirm');
  }
}

class ValidateScrapOrder {
  final ScrapOrderRepository r;
  ValidateScrapOrder(this.r);

  Future<Map<String, dynamic>> call(ScrapOrderFormModel f) {
    if (f.encryption == null) throw Exception('Scrap Order must be confirmed before validating');
    return r.update(f.encryption!, f, 'validate');
  }
}

class CancelScrapOrder {
  final ScrapOrderRepository r;
  CancelScrapOrder(this.r);

  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteScrapOrder {
  final ScrapOrderRepository r;
  DeleteScrapOrder(this.r);

  Future<void> call(int id) => r.delete(id);
}

class GetScrapOrderProductsByLocation {
  final ScrapOrderRepository r;
  GetScrapOrderProductsByLocation(this.r);

  Future<List<Map<String, dynamic>>> call(int locationId) => r.getProductsByLocation(locationId);
}

class CheckScrapOrderStock {
  final ScrapOrderRepository r;
  CheckScrapOrderStock(this.r);

  Future<double> call(int productId, int locationId) => r.checkStock(productId, locationId);
}

class GetScrapOrderSteps {
  final ScrapOrderRepository r;
  GetScrapOrderSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveScrapOrder {
  final ScrapOrderRepository r;
  ApproveScrapOrder(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectScrapOrder {
  final ScrapOrderRepository r;
  RejectScrapOrder(this.r);

  Future<void> call(int id) => r.reject(id);
}