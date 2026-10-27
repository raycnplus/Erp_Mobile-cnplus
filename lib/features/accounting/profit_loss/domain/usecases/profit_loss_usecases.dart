import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/repositories/profit_loss_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/models/profit_loss_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/datasources/profit_loss_remote_datasource.dart' show ExportUrlInfo;

class GetProfitLossReport {
  final ProfitLossRepository r;
  GetProfitLossReport(this.r);
  Future<ProfitLossResult> call({required List<String> dates}) => r.getReport(dates: dates);
}

class GetProfitLossExportPdfUrl {
  final ProfitLossRepository r;
  GetProfitLossExportPdfUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportPdfUrl(dates: dates, filterType: filterType);
}

class GetProfitLossExportExcelUrl {
  final ProfitLossRepository r;
  GetProfitLossExportExcelUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportExcelUrl(dates: dates, filterType: filterType);
}