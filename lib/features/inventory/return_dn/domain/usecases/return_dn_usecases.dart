import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/repositories/return_dn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/models/return_dn_models.dart';

class GetRDNList {
  final ReturnDNRepository r;
  GetRDNList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetRDNDetail {
  final ReturnDNRepository r;
  GetRDNDetail(this.r);
  Future<ReturnDNDetailModel> call(String enc) => r.getDetail(enc);
}

class GetRDNFormOptions {
  final ReturnDNRepository r;
  GetRDNFormOptions(this.r);
  Future<ReturnDNFormOptions> call() => r.getFormOptions();
}

class GetValidatedDNs {
  final ReturnDNRepository r;
  GetValidatedDNs(this.r);
  Future<List<DNOption>> call({int? excludeReturnDeliveryNoteId}) =>
      r.getValidatedDNs(excludeReturnDeliveryNoteId: excludeReturnDeliveryNoteId);
}

class GetDNBySO {
  final ReturnDNRepository r;
  GetDNBySO(this.r);
  Future<List<DNOption>> call(int soId) => r.getDNBySO(soId);
}

class GetItemsByDN {
  final ReturnDNRepository r;
  GetItemsByDN(this.r);
  Future<List<ReturnDNItem>> call(List<int> dnIds) => r.getItemsByDN(dnIds);
}

class GetReplaceProducts {
  final ReturnDNRepository r;
  GetReplaceProducts(this.r);
  Future<ReplaceProductsResult> call(int idDeliveryNote) => r.getReplaceProducts(idDeliveryNote);
}

class GetReplaceProductStock {
  final ReturnDNRepository r;
  GetReplaceProductStock(this.r);
  Future<double> call({required int idProduct, required int idDeliveryNote}) =>
      r.getReplaceProductStock(idProduct: idProduct, idDeliveryNote: idDeliveryNote);
}

class SaveReturnDN {
  final ReturnDNRepository r;
  SaveReturnDN(this.r);
  Future<Map<String, dynamic>> call(ReturnDNFormModel f) {
    if (f.isEditMode && f.encryption != null) return r.update(f.encryption!, f, 'save');
    return r.store(f, 'save');
  }
}

class ConfirmReturnDN {
  final ReturnDNRepository r;
  ConfirmReturnDN(this.r);
  Future<Map<String, dynamic>> call(ReturnDNFormModel f) {
    if (f.encryption == null) throw Exception('Return DN must be saved before confirming');
    return r.update(f.encryption!, f, 'confirm');
  }
}

class ValidateReturnDN {
  final ReturnDNRepository r;
  ValidateReturnDN(this.r);
  Future<Map<String, dynamic>> call(ReturnDNFormModel f) {
    if (f.encryption == null) throw Exception('Return DN must be confirmed before validating');
    return r.update(f.encryption!, f, 'validate');
  }
}

class CancelReturnDN {
  final ReturnDNRepository r;
  CancelReturnDN(this.r);
  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteReturnDN {
  final ReturnDNRepository r;
  DeleteReturnDN(this.r);
  Future<void> call(int id) => r.delete(id);
}

class SaveRDNTracking {
  final ReturnDNRepository r;
  SaveRDNTracking(this.r);
  Future<Map<String, dynamic>> call({required int idReturnDeliveryNoteItem, List<Map<String, dynamic>>? trackingData}) =>
      r.saveTracking(idReturnDeliveryNoteItem: idReturnDeliveryNoteItem, trackingData: trackingData);
}

class GetRDNSteps {
  final ReturnDNRepository r;
  GetRDNSteps(this.r);
  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveReturnDN {
  final ReturnDNRepository r;
  ApproveReturnDN(this.r);
  Future<void> call(int id) => r.approve(id);
}

class RejectReturnDN {
  final ReturnDNRepository r;
  RejectReturnDN(this.r);
  Future<void> call(int id) => r.reject(id);
}