import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/repositories/check_balance_journal_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/models/check_balance_journal_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/datasources/check_balance_journal_remote_datasource.dart' show ExportUrlInfo;

class GetCheckBalanceJournalReport {
  final CheckBalanceJournalRepository r;
  GetCheckBalanceJournalReport(this.r);
  Future<CheckBalanceJournalResult> call({
    String? dateFrom,
    String? dateTo,
  }) => r.getReport(dateFrom: dateFrom, dateTo: dateTo);
}

class GetCheckBalanceJournalExportPdfUrl {
  final CheckBalanceJournalRepository r;
  GetCheckBalanceJournalExportPdfUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);
}

class GetCheckBalanceJournalExportExcelUrl {
  final CheckBalanceJournalRepository r;
  GetCheckBalanceJournalExportExcelUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}