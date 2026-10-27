import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/datasources/balance_sheet_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/models/balance_sheet_models.dart';

class BalanceSheetRepository {
  final BalanceSheetRemoteDataSource ds;
  BalanceSheetRepository(this.ds);

  Future<BalanceSheetResult> getReport({required List<String> dates}) => ds.getReport(dates: dates);

  ExportUrlInfo getExportPdfUrl({required List<String> dates, String? filterType}) =>
      ds.getExportPdfUrl(dates: dates, filterType: filterType);

  ExportUrlInfo getExportExcelUrl({required List<String> dates, String? filterType}) =>
      ds.getExportExcelUrl(dates: dates, filterType: filterType);
}