import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/repositories/cash_bank_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/models/cash_bank_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/datasources/cash_bank_report_remote_datasource.dart' show ExportUrlInfo;

class GetCashBankReport {
  final CashBankReportRepository r;
  GetCashBankReport(this.r);
  Future<CashBankReportResult> call({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => r.getReport(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);
}

class GetCashBankReportFormOptions {
  final CashBankReportRepository r;
  GetCashBankReportFormOptions(this.r);
  Future<CashBankReportFormOptions> call() => r.getFormOptions();
}

class GetCashBankReportExportPdfUrl {
  final CashBankReportRepository r;
  GetCashBankReportExportPdfUrl(this.r);
  ExportUrlInfo call({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => r.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);
}

class GetCashBankReportExportExcelUrl {
  final CashBankReportRepository r;
  GetCashBankReportExportExcelUrl(this.r);
  ExportUrlInfo call({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => r.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);
}