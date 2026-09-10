import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/repositories/invoice_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/models/invoice_payment_models.dart';

class GetInvoicePaymentList {
  final InvoicePaymentRepository r;
  GetInvoicePaymentList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? search, String? status, String? invoiceType}) =>
      r.getList(page: page, perPage: perPage, search: search, status: status, invoiceType: invoiceType);
}

class GetInvoicePaymentDetail {
  final InvoicePaymentRepository r;
  GetInvoicePaymentDetail(this.r);
  Future<InvoicePaymentDetailModel> call(String enc) => r.getDetail(enc);
}

class GetInvoicePaymentFormOptions {
  final InvoicePaymentRepository r;
  GetInvoicePaymentFormOptions(this.r);
  Future<InvoicePaymentFormOptions> call() => r.getFormOptions();
}

class GetCustomerInvoices {
  final InvoicePaymentRepository r;
  GetCustomerInvoices(this.r);
  Future<List<InvoiceOption>> call(int idCustomer, String invoiceType) => r.getInvoices(idCustomer, invoiceType);
}

class SaveInvoicePayment {
  final InvoicePaymentRepository r;
  SaveInvoicePayment(this.r);
  Future<Map<String, dynamic>> call(InvoicePaymentFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class ConfirmInvoicePayment {
  final InvoicePaymentRepository r;
  ConfirmInvoicePayment(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.confirm(encryption);
}

class PostInvoicePayment {
  final InvoicePaymentRepository r;
  PostInvoicePayment(this.r);
  Future<Map<String, dynamic>> call(String encryption, {String? journalTransactionDate}) =>
      r.post(encryption, journalTransactionDate: journalTransactionDate);
}

class UnpostInvoicePayment {
  final InvoicePaymentRepository r;
  UnpostInvoicePayment(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.unpost(encryption);
}

class CancelInvoicePayment {
  final InvoicePaymentRepository r;
  CancelInvoicePayment(this.r);
  Future<Map<String, dynamic>> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteInvoicePayment {
  final InvoicePaymentRepository r;
  DeleteInvoicePayment(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}

class BulkConfirmInvoicePayments {
  final InvoicePaymentRepository r;
  BulkConfirmInvoicePayments(this.r);
  Future<Map<String, dynamic>> call(List<int> ids) {
    if (ids.isEmpty) throw Exception('No payment selected');
    return r.bulkConfirm(ids);
  }
}

class BulkPostInvoicePayments {
  final InvoicePaymentRepository r;
  BulkPostInvoicePayments(this.r);
  Future<Map<String, dynamic>> call(List<int> ids, {String? journalTransactionDate}) {
    if (ids.isEmpty) throw Exception('No payment selected');
    return r.bulkPost(ids, journalTransactionDate: journalTransactionDate);
  }
}