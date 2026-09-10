import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/datasources/return_rn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/models/return_rn_models.dart';

class ReturnRNRepository {
  final ReturnRNRemoteDataSource ds;
  ReturnRNRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ReturnRNDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<ReturnRNFormOptions> getFormOptions() => ds.getFormOptions();
  Future<List<ValidatedRNOption>> getValidatedRNs() => ds.getValidatedRNs();
  Future<List<RNSourceItem>> getItemsByRN(List<int> idsReceiptNote) => ds.getItemsByRN(idsReceiptNote);

  Future<Map<String, dynamic>> store(ReturnRNFormModel f, String status) => ds.store(f, status);
  Future<Map<String, dynamic>> update(String encryption, ReturnRNFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> saveTracking({required int idReturnReceiptNoteItem, List<Map<String, dynamic>>? trackingData}) =>
      ds.saveTracking(idReturnReceiptNoteItem: idReturnReceiptNoteItem, trackingData: trackingData);

  Future<Map<String, dynamic>> getLotSerialsSorted(int productId, int locationId) =>
      ds.getLotSerialsSorted(productId, locationId);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
}