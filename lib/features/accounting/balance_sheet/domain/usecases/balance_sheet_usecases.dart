import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/repositories/balance_sheet_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/models/balance_sheet_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/datasources/balance_sheet_remote_datasource.dart' show ExportUrlInfo;

class GetBalanceSheetReport {
  final BalanceSheetRepository r;
  GetBalanceSheetReport(this.r);
  Future<BalanceSheetResult> call({required List<String> dates}) => r.getReport(dates: dates);
}

class GetBalanceSheetExportPdfUrl {
  final BalanceSheetRepository r;
  GetBalanceSheetExportPdfUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportPdfUrl(dates: dates, filterType: filterType);
}

class GetBalanceSheetExportExcelUrl {
  final BalanceSheetRepository r;
  GetBalanceSheetExportExcelUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportExcelUrl(dates: dates, filterType: filterType);
}