import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/repositories/general_ledger_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/models/general_ledger_models.dart';

class GetGeneralLedgerReport {
  final GeneralLedgerRepository r;
  GetGeneralLedgerReport(this.r);
  Future<GeneralLedgerReportResult> call({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => r.getReport(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);
}

class GetGeneralLedgerFormOptions {
  final GeneralLedgerRepository r;
  GetGeneralLedgerFormOptions(this.r);
  Future<GeneralLedgerFormOptions> call() => r.getFormOptions();
}

class GetGeneralLedgerExportPdfUrl {
  final GeneralLedgerRepository r;
  GetGeneralLedgerExportPdfUrl(this.r);
  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => r.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);
}

class GetGeneralLedgerExportExcelUrl {
  final GeneralLedgerRepository r;
  GetGeneralLedgerExportExcelUrl(this.r);
  ExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) => r.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);
}