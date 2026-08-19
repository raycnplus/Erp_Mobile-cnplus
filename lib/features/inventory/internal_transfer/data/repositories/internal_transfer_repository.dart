import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/datasources/internal_transfer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/models/internal_transfer_models.dart';

class InternalTransferRepository {
  final InternalTransferRemoteDataSource ds;
  InternalTransferRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<InternalTransferDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<InternalTransferFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(InternalTransferFormModel f, String status) => ds.store(f, status);
  Future<Map<String, dynamic>> update(String encryption, InternalTransferFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(int id) => ds.delete(id);

  Future<Map<String, dynamic>> saveTracking({
    required int idInternalTransferItem,
    List<Map<String, dynamic>>? trackingData,
  }) => ds.saveTracking(
        idInternalTransferItem: idInternalTransferItem,
        trackingData: trackingData,
      );

  Future<List<Map<String, dynamic>>> getProductsByLocation(int locationId) =>
      ds.getProductsByLocation(locationId);
  Future<double> checkStock(int productId, int locationId) => ds.checkStock(productId, locationId);
  Future<Map<String, dynamic>> getSteps(int id) => ds.getSteps(id);
  Future<void> approve(int id) => ds.approve(id);
  Future<void> reject(int id) => ds.reject(id);
  Future<Map<String, dynamic>> getLotSerialsSorted(int productId, int locationId, {int? idInternalTransferItem}) =>
      ds.getLotSerialsSorted(productId, locationId, idInternalTransferItem: idInternalTransferItem);
}