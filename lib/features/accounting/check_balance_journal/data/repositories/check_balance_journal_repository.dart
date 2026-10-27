import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/datasources/check_balance_journal_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/models/check_balance_journal_models.dart';

class CheckBalanceJournalRepository {
  final CheckBalanceJournalRemoteDataSource ds;
  CheckBalanceJournalRepository(this.ds);

  Future<CheckBalanceJournalResult> getReport({
    String? dateFrom,
    String? dateTo,
  }) => ds.getReport(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportPdfUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportExcelUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}