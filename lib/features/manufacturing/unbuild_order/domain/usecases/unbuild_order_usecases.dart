import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/repositories/unbuild_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';

class GetUOList {
  final UnbuildOrderRepository r;
  GetUOList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetUODetail {
  final UnbuildOrderRepository r;
  GetUODetail(this.r);

  Future<UnbuildOrderDetailModel> call(String enc) => r.getDetail(enc);
}

class GetUOFormOptions {
  final UnbuildOrderRepository r;
  GetUOFormOptions(this.r);

  Future<UnbuildOrderFormOptions> call() => r.getFormOptions();
}

class GenerateUOReference {
  final UnbuildOrderRepository r;
  GenerateUOReference(this.r);

  Future<String> call() => r.generateReference();
}

class GetUOComponentsPreview {
  final UnbuildOrderRepository r;
  GetUOComponentsPreview(this.r);

  Future<List<UOPreviewComponent>> call(List<UOPreviewRequestItem> items) {
    if (items.isEmpty) throw Exception('No unbuild products provided');
    return r.getComponentsPreview(items);
  }
}

class GetUOManufacturingOrderDetails {
  final UnbuildOrderRepository r;
  GetUOManufacturingOrderDetails(this.r);

  Future<UOManufacturingOrderDetails> call(int moId) => r.getManufacturingOrderDetails(moId);
}

class SaveUnbuildOrder {
  final UnbuildOrderRepository r;
  SaveUnbuildOrder(this.r);

  Future<String> call(UnbuildOrderFormModel f, String status) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status);
    }
    return r.store(f, status);
  }
}

class DeleteUnbuildOrder {
  final UnbuildOrderRepository r;
  DeleteUnbuildOrder(this.r);

  Future<void> call(String enc) => r.delete(enc);
}

class ApproveUnbuildOrder {
  final UnbuildOrderRepository r;
  ApproveUnbuildOrder(this.r);

  Future<void> call(String enc) => r.approve(enc);
}

class RejectUnbuildOrder {
  final UnbuildOrderRepository r;
  RejectUnbuildOrder(this.r);

  Future<void> call(String enc) => r.reject(enc);
}

class GetUOSteps {
  final UnbuildOrderRepository r;
  GetUOSteps(this.r);

  Future<Map<String, dynamic>> call(String enc) => r.getSteps(enc);
}