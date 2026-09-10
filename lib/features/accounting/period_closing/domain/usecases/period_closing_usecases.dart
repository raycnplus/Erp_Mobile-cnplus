import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/repositories/period_closing_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';

class GetPeriodClosingList {
  final PeriodClosingRepository r;

  GetPeriodClosingList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 15, String? status, String? type}) =>
      r.getList(page: page, perPage: perPage, status: status, type: type);
}

class GetPeriodClosingDetail {
  final PeriodClosingRepository r;

  GetPeriodClosingDetail(this.r);

  Future<PeriodClosingDetailModel> call(String encryption) => r.getDetail(encryption);
}

class SavePeriodClosing {
  final PeriodClosingRepository r;

  SavePeriodClosing(this.r);

  Future<PeriodClosingModel> call(PeriodClosingFormModel f) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f);
    }
    return r.store(f);
  }
}

class DeletePeriodClosing {
  final PeriodClosingRepository r;

  DeletePeriodClosing(this.r);

  Future<void> call(String encryption) => r.delete(encryption);
}

class PostPeriodClosing {
  final PeriodClosingRepository r;

  PostPeriodClosing(this.r);

  Future<PeriodClosingModel> call(String encryption) => r.post(encryption);
}

class GetPeriodClosingBalanceDetail {
  final PeriodClosingRepository r;

  GetPeriodClosingBalanceDetail(this.r);

  Future<List<PeriodClosingBalanceRow>> call({required int year, String type = 'MONTHLY', int? month}) =>
      r.getBalanceDetail(year: year, type: type, month: month);
}