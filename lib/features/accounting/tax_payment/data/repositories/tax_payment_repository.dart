import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/datasources/tax_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';

class TaxPaymentRepository {
  final TaxPaymentRemoteDataSource ds;

  TaxPaymentRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<TaxPaymentDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<List<TaxTransactionOption>> searchTransactions(String term, {int? excludeId}) =>
      ds.searchTransactions(term, excludeId: excludeId);

  Future<String> store(TaxPaymentFormModel f) => ds.store(f);

  Future<String> update(String enc, TaxPaymentFormModel f) => ds.update(enc, f);

  Future<String> post(String enc) => ds.post(enc);

  Future<String> unpost(String enc) => ds.unpost(enc);

  Future<void> delete(String enc) => ds.delete(enc);
}