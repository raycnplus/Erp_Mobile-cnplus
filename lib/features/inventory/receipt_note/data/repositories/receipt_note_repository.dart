import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/datasources/receipt_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';

class ReceiptNoteRepository {
  final ReceiptNoteRemoteDataSource ds;
  ReceiptNoteRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ReceiptNoteDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<ReceiptNoteFormOptions> getFormOptions() => ds.getFormOptions();
  Future<ReceiptNoteInventorySettings> getInventorySettings(int productId) =>
      ds.getInventorySettings(productId);

  Future<String> save(ReceiptNoteFormModel f) => ds.save(f);
  Future<Map<String, dynamic>> confirm(ReceiptNoteFormModel f) => ds.confirm(f);
  Future<Map<String, dynamic>> validateReceipt(ReceiptNoteFormModel f, {bool? allowBackorder}) =>
      ds.validateReceipt(f, allowBackorder: allowBackorder);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<void> saveTracking({
    required int idReceiptNoteItem,
    required double receivedQty,
    required List<ReceiptNoteLotSerial> trackingData,
  }) =>
      ds.saveTracking(
        idReceiptNoteItem: idReceiptNoteItem,
        receivedQty: receivedQty,
        trackingData: trackingData,
      );

  Future<Map<String, dynamic>> createReturnFromReceiptNote(String encryption) =>
      ds.createReturnFromReceiptNote(encryption);

  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
}