import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/datasources/return_dn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/models/return_dn_models.dart';

class ReturnDNRepository {
  final ReturnDNRemoteDataSource ds;
  ReturnDNRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ReturnDNDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<ReturnDNFormOptions> getFormOptions() => ds.getFormOptions();
  Future<List<DNOption>> getValidatedDNs({int? excludeReturnDeliveryNoteId}) =>
      ds.getValidatedDNs(excludeReturnDeliveryNoteId: excludeReturnDeliveryNoteId);
  Future<List<DNOption>> getDNBySO(int soId) => ds.getDNBySO(soId);
  Future<List<ReturnDNItem>> getItemsByDN(List<int> dnIds) => ds.getItemsByDN(dnIds);
  Future<ReplaceProductsResult> getReplaceProducts(int idDeliveryNote) => ds.getReplaceProducts(idDeliveryNote);
  Future<double> getReplaceProductStock({required int idProduct, required int idDeliveryNote}) =>
      ds.getReplaceProductStock(idProduct: idProduct, idDeliveryNote: idDeliveryNote);

  Future<Map<String, dynamic>> store(ReturnDNFormModel f, String status) => ds.store(f, status);
  Future<Map<String, dynamic>> update(String encryption, ReturnDNFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> saveTracking({required int idReturnDeliveryNoteItem, List<Map<String, dynamic>>? trackingData}) =>
      ds.saveTracking(idReturnDeliveryNoteItem: idReturnDeliveryNoteItem, trackingData: trackingData);

  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
}