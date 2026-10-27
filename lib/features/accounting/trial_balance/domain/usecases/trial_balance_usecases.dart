import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/repositories/trial_balance_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/models/trial_balance_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/datasources/trial_balance_remote_datasource.dart' show ExportUrlInfo;

class GetTrialBalanceReport {
  final TrialBalanceRepository r;
  GetTrialBalanceReport(this.r);
  Future<TrialBalanceResult> call({
    String? dateFrom,
    String? dateTo,
  }) => r.getReport(dateFrom: dateFrom, dateTo: dateTo);
}

class GetTrialBalanceExportPdfUrl {
  final TrialBalanceRepository r;
  GetTrialBalanceExportPdfUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);
}

class GetTrialBalanceExportExcelUrl {
  final TrialBalanceRepository r;
  GetTrialBalanceExportExcelUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}