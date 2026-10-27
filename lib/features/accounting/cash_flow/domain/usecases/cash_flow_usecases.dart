import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/repositories/cash_flow_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/models/cash_flow_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/datasources/cash_flow_remote_datasource.dart' show ExportUrlInfo;

class GetCashFlowReport {
  final CashFlowRepository r;
  GetCashFlowReport(this.r);
  Future<CashFlowResult> call({required List<String> dates}) => r.getReport(dates: dates);
}

class GetCashFlowExportPdfUrl {
  final CashFlowRepository r;
  GetCashFlowExportPdfUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportPdfUrl(dates: dates, filterType: filterType);
}

class GetCashFlowExportExcelUrl {
  final CashFlowRepository r;
  GetCashFlowExportExcelUrl(this.r);
  ExportUrlInfo call({required List<String> dates, String? filterType}) =>
      r.getExportExcelUrl(dates: dates, filterType: filterType);
}