import 'package:erp_mobile_cnplus/features/purchase/bill/data/repositories/bill_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/data/models/bill_models.dart';

class GetBillList {
  final BillRepository r;

  GetBillList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetBillDetail {
  final BillRepository r;

  GetBillDetail(this.r);

  Future<BillDetailModel> call(String enc) => r.getDetail(enc);
}

class GetBillFormOptions {
  final BillRepository r;

  GetBillFormOptions(this.r);

  Future<BillFormOptions> call() => r.getFormOptions();
}

class SaveBill {
  final BillRepository r;

  SaveBill(this.r);

  Future<String> call(BillFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelBill {
  final BillRepository r;

  CancelBill(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteBill {
  final BillRepository r;

  DeleteBill(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateBillPayment {
  final BillRepository r;

  CreateBillPayment(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createPayment(id);
}

class GetBillPriceFromList {
  final BillRepository r;

  GetBillPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApproveBill {
  final BillRepository r;

  ApproveBill(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectBill {
  final BillRepository r;

  RejectBill(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetBillSteps {
  final BillRepository r;

  GetBillSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}