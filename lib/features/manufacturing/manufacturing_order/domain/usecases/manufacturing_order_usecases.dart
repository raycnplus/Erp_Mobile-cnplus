import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/repositories/manufacturing_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';

class GetMOList {
  final ManufacturingOrderRepository r;
  GetMOList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetMODetail {
  final ManufacturingOrderRepository r;
  GetMODetail(this.r);

  Future<ManufacturingOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetMOFormOptions {
  final ManufacturingOrderRepository r;
  GetMOFormOptions(this.r);

  Future<ManufacturingOrderFormOptions> call() => r.getFormOptions();
}

class GetMOProductBoms {
  final ManufacturingOrderRepository r;
  GetMOProductBoms(this.r);

  Future<MOProductBomsResult> call(int productId) => r.getProductBoms(productId);
}

class GetMOBomDetails {
  final ManufacturingOrderRepository r;
  GetMOBomDetails(this.r);

  Future<MOBomDetail?> call(int bomId) => r.getBomDetails(bomId);
}

class GetMOBomComponents {
  final ManufacturingOrderRepository r;
  GetMOBomComponents(this.r);

  Future<List<MOBomComponent>> call(int bomId, {double qty = 1}) =>
      r.getBomComponents(bomId, qty: qty);
}

class GetMOPlanMaterials {
  final ManufacturingOrderRepository r;
  GetMOPlanMaterials(this.r);

  Future<List<MOPlanMaterial>> call({
    required int bomId,
    double qty = 1,
    required int warehouseId,
    required int locationId,
    int? manufacturingOrderId,
  }) => r.getPlanMaterials(
        bomId: bomId,
        qty: qty,
        warehouseId: warehouseId,
        locationId: locationId,
        manufacturingOrderId: manufacturingOrderId,
      );
}

class SaveManufacturingOrder {
  final ManufacturingOrderRepository r;
  SaveManufacturingOrder(this.r);

  Future<String> call(ManufacturingOrderFormModel f, String status) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status);
    }
    return r.store(f, status);
  }
}

class DeleteManufacturingOrder {
  final ManufacturingOrderRepository r;
  DeleteManufacturingOrder(this.r);

  Future<void> call(String enc) => r.delete(enc);
}

class ApproveManufacturingOrder {
  final ManufacturingOrderRepository r;
  ApproveManufacturingOrder(this.r);

  Future<void> call(String enc) => r.approve(enc);
}

class RejectManufacturingOrder {
  final ManufacturingOrderRepository r;
  RejectManufacturingOrder(this.r);

  Future<void> call(String enc) => r.reject(enc);
}

class GetMOSteps {
  final ManufacturingOrderRepository r;
  GetMOSteps(this.r);

  Future<Map<String, dynamic>> call(String enc) => r.getSteps(enc);
}

class CreateUnbuildFromMO {
  final ManufacturingOrderRepository r;
  CreateUnbuildFromMO(this.r);

  Future<MOCreateUnbuildResult> call(String enc) => r.createUnbuild(enc);
}

class StartMOOperation {
  final ManufacturingOrderRepository r;
  StartMOOperation(this.r);

  Future<Map<String, dynamic>> call(int moId, int bomOperationId) =>
      r.startOperation(moId, bomOperationId);
}

class PauseMOOperation {
  final ManufacturingOrderRepository r;
  PauseMOOperation(this.r);

  Future<Map<String, dynamic>> call(int trackingId) => r.pauseOperation(trackingId);
}

class ResumeMOOperation {
  final ManufacturingOrderRepository r;
  ResumeMOOperation(this.r);

  Future<Map<String, dynamic>> call(int trackingId) => r.resumeOperation(trackingId);
}

class CompleteMOOperation {
  final ManufacturingOrderRepository r;
  CompleteMOOperation(this.r);

  Future<Map<String, dynamic>> call(int trackingId) => r.completeOperation(trackingId);
}
