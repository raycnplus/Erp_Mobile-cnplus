import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/repositories/purchase_request_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';

class GetPRList {
  final PurchaseRequestRepository r;

  GetPRList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) {
    return r.getList(
      page: page,
      perPage: perPage,
      status: status,
      search: search,
    );
  }
}

class GetPRDetail {
  final PurchaseRequestRepository r;

  GetPRDetail(this.r);

  Future<PurchaseRequestDetailModel> call(String enc) {
    return r.getDetail(enc);
  }
}

class GetPRFormOptions {
  final PurchaseRequestRepository r;

  GetPRFormOptions(this.r);

  Future<PurchaseRequestFormOptions> call() {
    return r.getFormOptions();
  }
}

class SavePurchaseRequest {
  final PurchaseRequestRepository r;

  SavePurchaseRequest(this.r);

  Future<String> call(PurchaseRequestFormModel f, String status) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status);
    }
    return r.store(f, status);
  }
}

class CancelPurchaseRequest {
  final PurchaseRequestRepository r;

  CancelPurchaseRequest(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) {
      throw Exception('Cancel reason is required');
    }
    return r.cancel(id, reason);
  }
}

class DeletePurchaseRequest {
  final PurchaseRequestRepository r;

  DeletePurchaseRequest(this.r);

  Future<void> call(int id) {
    return r.delete(id);
  }
}

class CreateRfqFromPR {
  final PurchaseRequestRepository r;

  CreateRfqFromPR(this.r);

  Future<Map<String, dynamic>> call(int id) {
    return r.createRfq(id);
  }
}

class CreateDpFromPR {
  final PurchaseRequestRepository r;

  CreateDpFromPR(this.r);

  Future<Map<String, dynamic>> call(int id) {
    return r.createDp(id);
  }
}

class ApprovePurchaseRequest {
  final PurchaseRequestRepository r;

  ApprovePurchaseRequest(this.r);

  Future<void> call(int id) {
    return r.approve(id);
  }
}

class RejectPurchaseRequest {
  final PurchaseRequestRepository r;

  RejectPurchaseRequest(this.r);

  Future<void> call(int id) {
    return r.reject(id);
  }
}

class GetPRSteps {
  final PurchaseRequestRepository r;

  GetPRSteps(this.r);

  Future<Map<String, dynamic>> call(int id) {
    return r.getSteps(id);
  }
}