import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/datasources/general_ledger_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/models/general_ledger_models.dart';

class GeneralLedgerRepository {
  final GeneralLedgerRemoteDataSource ds;
  GeneralLedgerRepository(this.ds);

  Future<GeneralLedgerReportResult> getReport({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => ds.getReport(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);

  Future<GeneralLedgerFormOptions> getFormOptions() => ds.getFormOptions();

  ExportUrlInfo getExportPdfUrl({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => ds.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);

  ExportUrlInfo getExportExcelUrl({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => ds.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);
}