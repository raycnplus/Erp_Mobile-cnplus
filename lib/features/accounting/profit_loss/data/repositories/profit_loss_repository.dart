import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/datasources/profit_loss_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/models/profit_loss_models.dart';

class ProfitLossRepository {
  final ProfitLossRemoteDataSource ds;
  ProfitLossRepository(this.ds);

  Future<ProfitLossResult> getReport({required List<String> dates}) => ds.getReport(dates: dates);

  ExportUrlInfo getExportPdfUrl({required List<String> dates, String? filterType}) =>
      ds.getExportPdfUrl(dates: dates, filterType: filterType);

  ExportUrlInfo getExportExcelUrl({required List<String> dates, String? filterType}) =>
      ds.getExportExcelUrl(dates: dates, filterType: filterType);
}