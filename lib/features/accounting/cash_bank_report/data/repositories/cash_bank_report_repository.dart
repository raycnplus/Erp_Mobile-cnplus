import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/datasources/cash_bank_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/models/cash_bank_report_models.dart';

class CashBankReportRepository {
  final CashBankReportRemoteDataSource ds;
  CashBankReportRepository(this.ds);

  Future<CashBankReportResult> getReport({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => ds.getReport(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);

  Future<CashBankReportFormOptions> getFormOptions() => ds.getFormOptions();

  ExportUrlInfo getExportPdfUrl({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => ds.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);

  ExportUrlInfo getExportExcelUrl({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => ds.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);
}