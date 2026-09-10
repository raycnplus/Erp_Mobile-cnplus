import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/datasources/period_closing_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';

class PeriodClosingRepository {
  final PeriodClosingRemoteDataSource ds;
  PeriodClosingRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 15, String? status, String? type}) =>
      ds.getList(page: page, perPage: perPage, status: status, type: type);

  Future<PeriodClosingDetailModel> getDetail(String encryption) => ds.getDetail(encryption);

  Future<PeriodClosingModel> store(PeriodClosingFormModel f) => ds.store(f);

  Future<PeriodClosingModel> update(String encryption, PeriodClosingFormModel f) =>
      ds.update(encryption, f);

  Future<void> delete(String encryption) => ds.delete(encryption);

  Future<PeriodClosingModel> post(String encryption) => ds.post(encryption);

  Future<List<PeriodClosingBalanceRow>> getBalanceDetail({required int year, String type = 'MONTHLY', int? month}) =>
      ds.getBalanceDetail(year: year, type: type, month: month);
}