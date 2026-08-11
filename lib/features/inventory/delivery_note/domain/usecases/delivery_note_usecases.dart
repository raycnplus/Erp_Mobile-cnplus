import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/repositories/delivery_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';

class GetDNList {
  final DeliveryNoteRepository r;
  GetDNList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetDNDetail {
  final DeliveryNoteRepository r;
  GetDNDetail(this.r);

  Future<DeliveryNoteDetailModel> call(String enc) => r.getDetail(enc);
}

class GetDNFormOptions {
  final DeliveryNoteRepository r;
  GetDNFormOptions(this.r);

  Future<DeliveryNoteFormOptions> call() => r.getFormOptions();
}

class SaveDeliveryNote {
  final DeliveryNoteRepository r;
  SaveDeliveryNote(this.r);

  Future<Map<String, dynamic>> call(DeliveryNoteFormModel f) {
    if (f.isEditMode && f.encryption != null) {
      return r.update(f.encryption!, f, 'save');
    }
    return r.store(f, 'save');
  }
}

class ConfirmDeliveryNote {
  final DeliveryNoteRepository r;
  ConfirmDeliveryNote(this.r);

  Future<Map<String, dynamic>> call(DeliveryNoteFormModel f) {
    if (f.encryption == null) throw Exception('Delivery Note must be saved before confirming');
    return r.update(f.encryption!, f, 'confirm');
  }
}

class ValidateDeliveryNote {
  final DeliveryNoteRepository r;
  ValidateDeliveryNote(this.r);

  Future<Map<String, dynamic>> call(DeliveryNoteFormModel f) {
    if (f.encryption == null) throw Exception('Delivery Note must be confirmed before validating');
    return r.update(f.encryption!, f, 'validate');
  }
}

class CancelDeliveryNote {
  final DeliveryNoteRepository r;
  CancelDeliveryNote(this.r);

  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteDeliveryNote {
  final DeliveryNoteRepository r;
  DeleteDeliveryNote(this.r);

  Future<void> call(int id) => r.delete(id);
}

class SaveDNTracking {
  final DeliveryNoteRepository r;
  SaveDNTracking(this.r);

  Future<Map<String, dynamic>> call({
    required int idDeliveryNoteItem,
    required double deliveredQty,
    List<Map<String, dynamic>>? trackingData,
  }) => r.saveTracking(
        idDeliveryNoteItem: idDeliveryNoteItem,
        deliveredQty: deliveredQty,
        trackingData: trackingData,
      );
}

class GetDNProductsByLocation {
  final DeliveryNoteRepository r;
  GetDNProductsByLocation(this.r);

  Future<List<Map<String, dynamic>>> call(int locationId) => r.getProductsByLocation(locationId);
}

class CheckDNStock {
  final DeliveryNoteRepository r;
  CheckDNStock(this.r);

  Future<double> call(int productId, int locationId) => r.checkStock(productId, locationId);
}

class GetDNSteps {
  final DeliveryNoteRepository r;
  GetDNSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveDeliveryNote {
  final DeliveryNoteRepository r;
  ApproveDeliveryNote(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectDeliveryNote {
  final DeliveryNoteRepository r;
  RejectDeliveryNote(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetDNLotSerialsSorted {
  final DeliveryNoteRepository r;
  GetDNLotSerialsSorted(this.r);

  Future<Map<String, dynamic>> call(int productId, int locationId) =>
      r.getLotSerialsSorted(productId, locationId);
}

class CreateReturnFromDeliveryNote {
  final DeliveryNoteRepository r;
  CreateReturnFromDeliveryNote(this.r);

  Future<Map<String, dynamic>> call(String encryption) => r.createReturn(encryption);
}