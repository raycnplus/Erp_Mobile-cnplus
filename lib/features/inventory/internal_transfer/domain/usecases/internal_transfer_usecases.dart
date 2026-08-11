import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/repositories/internal_transfer_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/models/internal_transfer_models.dart';

class GetITList {
  final InternalTransferRepository r;
  GetITList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetITDetail {
  final InternalTransferRepository r;
  GetITDetail(this.r);

  Future<InternalTransferDetailModel> call(String enc) => r.getDetail(enc);
}

class GetITFormOptions {
  final InternalTransferRepository r;
  GetITFormOptions(this.r);

  Future<InternalTransferFormOptions> call() => r.getFormOptions();
}

class SaveInternalTransfer {
  final InternalTransferRepository r;
  SaveInternalTransfer(this.r);

  Future<Map<String, dynamic>> call(InternalTransferFormModel f) {
    if (f.isEditMode && f.encryption != null) {
      return r.update(f.encryption!, f, 'save');
    }
    return r.store(f, 'save');
  }
}

class ConfirmInternalTransfer {
  final InternalTransferRepository r;
  ConfirmInternalTransfer(this.r);

  Future<Map<String, dynamic>> call(InternalTransferFormModel f) {
    if (f.encryption == null) throw Exception('Internal Transfer must be saved before confirming');
    return r.update(f.encryption!, f, 'confirm');
  }
}

class ValidateInternalTransfer {
  final InternalTransferRepository r;
  ValidateInternalTransfer(this.r);

  Future<Map<String, dynamic>> call(InternalTransferFormModel f) {
    if (f.encryption == null) throw Exception('Internal Transfer must be confirmed before validating');
    return r.update(f.encryption!, f, 'validate');
  }
}

class CancelInternalTransfer {
  final InternalTransferRepository r;
  CancelInternalTransfer(this.r);

  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteInternalTransfer {
  final InternalTransferRepository r;
  DeleteInternalTransfer(this.r);

  Future<void> call(int id) => r.delete(id);
}

class SaveITTracking {
  final InternalTransferRepository r;
  SaveITTracking(this.r);

  Future<Map<String, dynamic>> call({
    required int idInternalTransferItem,
    required double transferredQty,
    List<Map<String, dynamic>>? trackingData,
  }) => r.saveTracking(
        idInternalTransferItem: idInternalTransferItem,
        transferredQty: transferredQty,
        trackingData: trackingData,
      );
}

class GetITProductsByLocation {
  final InternalTransferRepository r;
  GetITProductsByLocation(this.r);

  Future<List<Map<String, dynamic>>> call(int locationId) => r.getProductsByLocation(locationId);
}

class CheckITStock {
  final InternalTransferRepository r;
  CheckITStock(this.r);

  Future<double> call(int productId, int locationId) => r.checkStock(productId, locationId);
}

class GetITSteps {
  final InternalTransferRepository r;
  GetITSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveInternalTransfer {
  final InternalTransferRepository r;
  ApproveInternalTransfer(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectInternalTransfer {
  final InternalTransferRepository r;
  RejectInternalTransfer(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetITLotSerialsSorted {
  final InternalTransferRepository r;
  GetITLotSerialsSorted(this.r);

  Future<Map<String, dynamic>> call(int productId, int locationId, {int? idInternalTransferItem}) =>
      r.getLotSerialsSorted(productId, locationId, idInternalTransferItem: idInternalTransferItem);
}