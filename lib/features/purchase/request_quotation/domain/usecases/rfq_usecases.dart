import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/repositories/rfq_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/models/rfq_models.dart';

class GetRfqList {
  final RfqRepository r;

  GetRfqList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetRfqDetail {
  final RfqRepository r;

  GetRfqDetail(this.r);

  Future<RfqDetailModel> call(String enc) => r.getDetail(enc);
}

class GetRfqFormOptions {
  final RfqRepository r;

  GetRfqFormOptions(this.r);

  Future<RfqFormOptions> call() => r.getFormOptions();
}

class SaveRfq {
  final RfqRepository r;

  SaveRfq(this.r);

  Future<String> call(RfqFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelRfq {
  final RfqRepository r;

  CancelRfq(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteRfq {
  final RfqRepository r;

  DeleteRfq(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreatePOFromRfq {
  final RfqRepository r;

  CreatePOFromRfq(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createPO(id);
}

class GetRfqSteps {
  final RfqRepository r;

  GetRfqSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveRfq {
  final RfqRepository r;

  ApproveRfq(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectRfq {
  final RfqRepository r;

  RejectRfq(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetRfqPriceFromList {
  final RfqRepository r;

  GetRfqPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class GetRfqLocationsByWarehouse {
  final RfqRepository r;

  GetRfqLocationsByWarehouse(this.r);

  Future<List<RfqLocationOption>> call(int warehouseId) => r.getLocationsByWarehouse(warehouseId);
}