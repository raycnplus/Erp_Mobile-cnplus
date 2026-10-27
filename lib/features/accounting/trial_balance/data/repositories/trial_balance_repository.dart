import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/datasources/trial_balance_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/models/trial_balance_models.dart';

class TrialBalanceRepository {
  final TrialBalanceRemoteDataSource ds;
  TrialBalanceRepository(this.ds);

  Future<TrialBalanceResult> getReport({
    String? dateFrom,
    String? dateTo,
  }) => ds.getReport(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportPdfUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportExcelUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}