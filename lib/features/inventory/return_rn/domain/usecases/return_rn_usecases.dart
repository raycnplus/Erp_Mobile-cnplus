import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/repositories/return_rn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/models/return_rn_models.dart';

class GetRRNList {
  final ReturnRNRepository r;
  GetRRNList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetRRNDetail {
  final ReturnRNRepository r;
  GetRRNDetail(this.r);
  Future<ReturnRNDetailModel> call(String enc) => r.getDetail(enc);
}

class GetRRNFormOptions {
  final ReturnRNRepository r;
  GetRRNFormOptions(this.r);
  Future<ReturnRNFormOptions> call() => r.getFormOptions();
}

class GetValidatedRNs {
  final ReturnRNRepository r;
  GetValidatedRNs(this.r);
  Future<List<ValidatedRNOption>> call() => r.getValidatedRNs();
}

class GetItemsByRN {
  final ReturnRNRepository r;
  GetItemsByRN(this.r);
  Future<List<RNSourceItem>> call(List<int> idsReceiptNote) => r.getItemsByRN(idsReceiptNote);
}

class SaveReturnRN {
  final ReturnRNRepository r;
  SaveReturnRN(this.r);
  Future<Map<String, dynamic>> call(ReturnRNFormModel f) {
    if (f.isEditMode && f.encryption != null) return r.update(f.encryption!, f, 'save');
    return r.store(f, 'save');
  }
}

class ConfirmReturnRN {
  final ReturnRNRepository r;
  ConfirmReturnRN(this.r);
  Future<Map<String, dynamic>> call(ReturnRNFormModel f) {
    if (f.encryption == null) throw Exception('Return RN must be saved before confirming');
    return r.update(f.encryption!, f, 'confirm');
  }
}

class ValidateReturnRN {
  final ReturnRNRepository r;
  ValidateReturnRN(this.r);
  Future<Map<String, dynamic>> call(ReturnRNFormModel f) {
    if (f.encryption == null) throw Exception('Return RN must be confirmed before validating');
    return r.update(f.encryption!, f, 'validate');
  }
}

class CancelReturnRN {
  final ReturnRNRepository r;
  CancelReturnRN(this.r);
  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteReturnRN {
  final ReturnRNRepository r;
  DeleteReturnRN(this.r);
  Future<void> call(int id) => r.delete(id);
}

class SaveRRNTracking {
  final ReturnRNRepository r;
  SaveRRNTracking(this.r);
  Future<Map<String, dynamic>> call({required int idReturnReceiptNoteItem, List<Map<String, dynamic>>? trackingData}) =>
      r.saveTracking(idReturnReceiptNoteItem: idReturnReceiptNoteItem, trackingData: trackingData);
}

class GetRRNLotSerialsSorted {
  final ReturnRNRepository r;
  GetRRNLotSerialsSorted(this.r);
  Future<Map<String, dynamic>> call(int productId, int locationId) => r.getLotSerialsSorted(productId, locationId);
}

class GetRRNSteps {
  final ReturnRNRepository r;
  GetRRNSteps(this.r);
  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveReturnRN {
  final ReturnRNRepository r;
  ApproveReturnRN(this.r);
  Future<void> call(int id) => r.approve(id);
}

class RejectReturnRN {
  final ReturnRNRepository r;
  RejectReturnRN(this.r);
  Future<void> call(int id) => r.reject(id);
}