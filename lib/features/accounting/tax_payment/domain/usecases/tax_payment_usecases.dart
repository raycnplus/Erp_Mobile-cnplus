import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/repositories/tax_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';

class GetTaxPaymentList {
  final TaxPaymentRepository r;

  GetTaxPaymentList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetTaxPaymentDetail {
  final TaxPaymentRepository r;

  GetTaxPaymentDetail(this.r);

  Future<TaxPaymentDetailModel> call(String enc) => r.getDetail(enc);
}

class SearchTaxTransactions {
  final TaxPaymentRepository r;

  SearchTaxTransactions(this.r);

  Future<List<TaxTransactionOption>> call(String term, {int? excludeId}) =>
      r.searchTransactions(term, excludeId: excludeId);
}

class SaveTaxPayment {
  final TaxPaymentRepository r;

  SaveTaxPayment(this.r);

  Future<String> call(TaxPaymentFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class PostTaxPayment {
  final TaxPaymentRepository r;

  PostTaxPayment(this.r);

  Future<String> call(String enc) => r.post(enc);
}

class UnpostTaxPayment {
  final TaxPaymentRepository r;

  UnpostTaxPayment(this.r);

  Future<String> call(String enc) => r.unpost(enc);
}

class DeleteTaxPayment {
  final TaxPaymentRepository r;

  DeleteTaxPayment(this.r);

  Future<void> call(String enc) => r.delete(enc);
}