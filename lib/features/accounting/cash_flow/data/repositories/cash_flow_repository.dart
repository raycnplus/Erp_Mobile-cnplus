import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/datasources/cash_flow_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/models/cash_flow_models.dart';

class CashFlowRepository {
  final CashFlowRemoteDataSource ds;
  CashFlowRepository(this.ds);

  Future<CashFlowResult> getReport({required List<String> dates}) => ds.getReport(dates: dates);

  ExportUrlInfo getExportPdfUrl({required List<String> dates, String? filterType}) =>
      ds.getExportPdfUrl(dates: dates, filterType: filterType);

  ExportUrlInfo getExportExcelUrl({required List<String> dates, String? filterType}) =>
      ds.getExportExcelUrl(dates: dates, filterType: filterType);
}