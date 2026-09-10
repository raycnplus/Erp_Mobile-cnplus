import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/repositories/bill_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';

class GetBillPaymentList {
  final BillPaymentRepository r;
  GetBillPaymentList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? search, String? status}) =>
      r.getList(page: page, perPage: perPage, search: search, status: status);
}

class GetBillPaymentDetail {
  final BillPaymentRepository r;
  GetBillPaymentDetail(this.r);
  Future<BillPaymentDetailModel> call(String enc) => r.getDetail(enc);
}

class GetBillPaymentFormOptions {
  final BillPaymentRepository r;
  GetBillPaymentFormOptions(this.r);
  Future<BillPaymentFormOptions> call() => r.getFormOptions();
}

class GetPayableBills {
  final BillPaymentRepository r;
  GetPayableBills(this.r);
  Future<List<BillOption>> call(int idVendor) => r.getBills(idVendor);
}

class SaveBillPayment {
  final BillPaymentRepository r;
  SaveBillPayment(this.r);
  Future<Map<String, dynamic>> call(BillPaymentFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class ConfirmBillPayment {
  final BillPaymentRepository r;
  ConfirmBillPayment(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.confirm(encryption);
}

class PostBillPayment {
  final BillPaymentRepository r;
  PostBillPayment(this.r);
  Future<Map<String, dynamic>> call(String encryption, {String? journalTransactionDate}) =>
      r.post(encryption, journalTransactionDate: journalTransactionDate);
}

class UnpostBillPayment {
  final BillPaymentRepository r;
  UnpostBillPayment(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.unpost(encryption);
}

class CancelBillPayment {
  final BillPaymentRepository r;
  CancelBillPayment(this.r);
  Future<Map<String, dynamic>> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteBillPayment {
  final BillPaymentRepository r;
  DeleteBillPayment(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}