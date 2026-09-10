import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/repositories/cash_bank_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';

class GetCashBankList {
  final CashBankRepository r;
  GetCashBankList(this.r);
  Future<Map<String, dynamic>> call({
    int page = 1, int perPage = 100, String? search, String? status,
    String? noteType, String? startDate, String? endDate,
  }) => r.getList(page: page, perPage: perPage, search: search, status: status,
      noteType: noteType, startDate: startDate, endDate: endDate);
}

class GetCashBankDetail {
  final CashBankRepository r;
  GetCashBankDetail(this.r);
  Future<CashBankDetailModel> call(String enc) => r.getDetail(enc);
}

class GetCashBankFormOptions {
  final CashBankRepository r;
  GetCashBankFormOptions(this.r);
  Future<CashBankFormOptions> call() => r.getFormOptions();
}

class SaveCashBank {
  final CashBankRepository r;
  SaveCashBank(this.r);
  Future<Map<String, dynamic>> call(CashBankFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f, 'save');
    return r.store(f, 'save');
  }
}

class PostCashBank {
  final CashBankRepository r;
  PostCashBank(this.r);
  Future<Map<String, dynamic>> call(CashBankFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f, 'post');
    return r.store(f, 'post');
  }
}

class UnpostCashBank {
  final CashBankRepository r;
  UnpostCashBank(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.unpost(encryption);
}

class DeleteCashBank {
  final CashBankRepository r;
  DeleteCashBank(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}

class BulkPostCashBank {
  final CashBankRepository r;
  BulkPostCashBank(this.r);
  Future<BulkPostResult> call(List<String> encryptions) {
    if (encryptions.isEmpty) throw Exception('Select at least one transaction to post');
    return r.bulkPost(encryptions);
  }
}