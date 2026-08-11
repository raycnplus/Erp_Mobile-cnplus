import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/datasources/delivery_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';

class DeliveryNoteRepository {
  final DeliveryNoteRemoteDataSource ds;
  DeliveryNoteRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<DeliveryNoteDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<DeliveryNoteFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(DeliveryNoteFormModel f, String status) => ds.store(f, status);
  Future<Map<String, dynamic>> update(String encryption, DeliveryNoteFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> saveTracking({
    required int idDeliveryNoteItem,
    required double deliveredQty,
    List<Map<String, dynamic>>? trackingData,
  }) => ds.saveTracking(
        idDeliveryNoteItem: idDeliveryNoteItem,
        deliveredQty: deliveredQty,
        trackingData: trackingData,
      );

  Future<List<Map<String, dynamic>>> getProductsByLocation(int locationId) =>
      ds.getProductsByLocation(locationId);
  Future<double> checkStock(int productId, int locationId) => ds.checkStock(productId, locationId);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getLotSerialsSorted(int productId, int locationId) =>
      ds.getLotSerialsSorted(productId, locationId);
  Future<Map<String, dynamic>> createReturn(String encryption) => ds.createReturn(encryption);
}