import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/repositories/receipt_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';

class GetRNList {
  final ReceiptNoteRepository r;

  GetRNList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetRNDetail {
  final ReceiptNoteRepository r;

  GetRNDetail(this.r);

  Future<ReceiptNoteDetailModel> call(String enc) => r.getDetail(enc);
}

class GetRNFormOptions {
  final ReceiptNoteRepository r;

  GetRNFormOptions(this.r);

  Future<ReceiptNoteFormOptions> call() => r.getFormOptions();
}

class GetRNInventorySettings {
  final ReceiptNoteRepository r;

  GetRNInventorySettings(this.r);

  Future<ReceiptNoteInventorySettings> call(int productId) => r.getInventorySettings(productId);
}

class SaveReceiptNote {
  final ReceiptNoteRepository r;

  SaveReceiptNote(this.r);

  Future<String> call(ReceiptNoteFormModel f) => r.save(f);
}

class ConfirmReceiptNote {
  final ReceiptNoteRepository r;

  ConfirmReceiptNote(this.r);

  Future<Map<String, dynamic>> call(ReceiptNoteFormModel f) => r.confirm(f);
}

class ValidateReceiptNote {
  final ReceiptNoteRepository r;

  ValidateReceiptNote(this.r);

  Future<Map<String, dynamic>> call(ReceiptNoteFormModel f, {bool? allowBackorder}) =>
      r.validateReceipt(f, allowBackorder: allowBackorder);
}

class CancelReceiptNote {
  final ReceiptNoteRepository r;

  CancelReceiptNote(this.r);

  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteReceiptNote {
  final ReceiptNoteRepository r;

  DeleteReceiptNote(this.r);

  Future<void> call(int id) => r.delete(id);
}

class SaveReceiptNoteTracking {
  final ReceiptNoteRepository r;

  SaveReceiptNoteTracking(this.r);

  Future<void> call({
    required int idReceiptNoteItem,
    required double receivedQty,
    required List<ReceiptNoteLotSerial> trackingData,
  }) =>
      r.saveTracking(
        idReceiptNoteItem: idReceiptNoteItem,
        receivedQty: receivedQty,
        trackingData: trackingData,
      );
}

class CreateReturnFromReceiptNote {
  final ReceiptNoteRepository r;

  CreateReturnFromReceiptNote(this.r);

  Future<Map<String, dynamic>> call(String encryption) => r.createReturnFromReceiptNote(encryption);
}

class ApproveReceiptNote {
  final ReceiptNoteRepository r;

  ApproveReceiptNote(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectReceiptNote {
  final ReceiptNoteRepository r;

  RejectReceiptNote(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetRNSteps {
  final ReceiptNoteRepository r;

  GetRNSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}