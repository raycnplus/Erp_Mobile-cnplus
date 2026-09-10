import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/datasources/manufacturing_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';

class ManufacturingOrderRepository {
  final ManufacturingOrderRemoteDataSource ds;
  ManufacturingOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<ManufacturingOrderDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<ManufacturingOrderFormOptions> getFormOptions() => ds.getFormOptions();

  Future<MOProductBomsResult> getProductBoms(int productId) => ds.getProductBoms(productId);
  Future<MOBomDetail?> getBomDetails(int bomId) => ds.getBomDetails(bomId);
  Future<List<MOBomComponent>> getBomComponents(int bomId, {double qty = 1}) =>
      ds.getBomComponents(bomId, qty: qty);
  Future<List<MOPlanMaterial>> getPlanMaterials({
    required int bomId,
    double qty = 1,
    required int warehouseId,
    required int locationId,
    int? manufacturingOrderId,
  }) => ds.getPlanMaterials(
        bomId: bomId,
        qty: qty,
        warehouseId: warehouseId,
        locationId: locationId,
        manufacturingOrderId: manufacturingOrderId,
      );

  Future<String> store(ManufacturingOrderFormModel f, String status) => ds.store(f, status);
  Future<String> update(String enc, ManufacturingOrderFormModel f, String status) => ds.update(enc, f, status);
  Future<void> delete(String enc) => ds.delete(enc);

  Future<void> approve(String enc) => ds.approve(enc);
  Future<void> reject(String enc) => ds.reject(enc);
  Future<Map<String, dynamic>> getSteps(String enc) => ds.getSteps(enc);
  Future<MOCreateUnbuildResult> createUnbuild(String enc) => ds.createUnbuild(enc);

  Future<Map<String, dynamic>> startOperation(int moId, int bomOperationId) =>
      ds.startOperation(moId, bomOperationId);
  Future<Map<String, dynamic>> pauseOperation(int trackingId) => ds.pauseOperation(trackingId);
  Future<Map<String, dynamic>> resumeOperation(int trackingId) => ds.resumeOperation(trackingId);
  Future<Map<String, dynamic>> completeOperation(int trackingId) => ds.completeOperation(trackingId);
}