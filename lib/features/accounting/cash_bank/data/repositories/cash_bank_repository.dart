import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/datasources/cash_bank_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';

class CashBankRepository {
  final CashBankRemoteDataSource ds;
  CashBankRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1, int perPage = 100, String? search, String? status,
    String? noteType, String? startDate, String? endDate,
  }) => ds.getList(page: page, perPage: perPage, search: search, status: status,
      noteType: noteType, startDate: startDate, endDate: endDate);

  Future<CashBankDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<CashBankFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(CashBankFormModel f, String action) => ds.store(f, action);
  Future<Map<String, dynamic>> update(String encryption, CashBankFormModel f, String action) =>
      ds.update(encryption, f, action);

  Future<void> delete(String encryption) => ds.delete(encryption);
  Future<Map<String, dynamic>> unpost(String encryption) => ds.unpost(encryption);
  Future<BulkPostResult> bulkPost(List<String> encryptions) => ds.bulkPost(encryptions);
}