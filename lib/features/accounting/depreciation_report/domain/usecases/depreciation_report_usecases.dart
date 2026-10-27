import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/repositories/depreciation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/models/depreciation_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/datasources/depreciation_report_remote_datasource.dart' show ExportUrlInfo;

class GetDepreciationReport {
  final DepreciationReportRepository r;
  GetDepreciationReport(this.r);
  Future<DepreciationReportResult> call({
    String? dateFrom,
    String? dateTo,
  }) => r.getReport(dateFrom: dateFrom, dateTo: dateTo);
}

class GetDepreciationReportExportPdfUrl {
  final DepreciationReportRepository r;
  GetDepreciationReportExportPdfUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);
}

class GetDepreciationReportExportExcelUrl {
  final DepreciationReportRepository r;
  GetDepreciationReportExportExcelUrl(this.r);
  ExportUrlInfo call({String? dateFrom, String? dateTo}) =>
      r.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}