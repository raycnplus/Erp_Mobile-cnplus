import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/datasources/bill_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';

class BillPaymentRepository {
  final BillPaymentRemoteDataSource ds;
  BillPaymentRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? search, String? status}) =>
      ds.getList(page: page, perPage: perPage, search: search, status: status);

  Future<BillPaymentDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<BillPaymentFormOptions> getFormOptions() => ds.getFormOptions();
  Future<List<BillOption>> getBills(int idVendor) => ds.getBills(idVendor);

  Future<Map<String, dynamic>> store(BillPaymentFormModel f) => ds.store(f);
  Future<Map<String, dynamic>> update(String encryption, BillPaymentFormModel f) => ds.update(encryption, f);

  Future<Map<String, dynamic>> confirm(String encryption) => ds.confirm(encryption);
  Future<Map<String, dynamic>> post(String encryption, {String? journalTransactionDate}) =>
      ds.post(encryption, journalTransactionDate: journalTransactionDate);
  Future<Map<String, dynamic>> unpost(String encryption) => ds.unpost(encryption);
  Future<Map<String, dynamic>> cancel(String encryption, String reason) => ds.cancel(encryption, reason);
  Future<void> delete(String encryption) => ds.delete(encryption);
}