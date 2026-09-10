import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/datasources/invoice_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/models/invoice_payment_models.dart';

class InvoicePaymentRepository {
  final InvoicePaymentRemoteDataSource ds;
  InvoicePaymentRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? status,
    String? invoiceType,
  }) =>
      ds.getList(page: page, perPage: perPage, search: search, status: status, invoiceType: invoiceType);

  Future<InvoicePaymentDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<InvoicePaymentFormOptions> getFormOptions() => ds.getFormOptions();
  Future<List<InvoiceOption>> getInvoices(int idCustomer, String invoiceType) => ds.getInvoices(idCustomer, invoiceType);

  Future<Map<String, dynamic>> store(InvoicePaymentFormModel f) => ds.store(f);
  Future<Map<String, dynamic>> update(String encryption, InvoicePaymentFormModel f) => ds.update(encryption, f);

  Future<Map<String, dynamic>> confirm(String encryption) => ds.confirm(encryption);
  Future<Map<String, dynamic>> post(String encryption, {String? journalTransactionDate}) =>
      ds.post(encryption, journalTransactionDate: journalTransactionDate);
  Future<Map<String, dynamic>> unpost(String encryption) => ds.unpost(encryption);
  Future<Map<String, dynamic>> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(String encryption) => ds.delete(encryption);

  Future<Map<String, dynamic>> bulkConfirm(List<int> ids) => ds.bulkConfirm(ids);
  Future<Map<String, dynamic>> bulkPost(List<int> ids, {String? journalTransactionDate}) =>
      ds.bulkPost(ids, journalTransactionDate: journalTransactionDate);
}