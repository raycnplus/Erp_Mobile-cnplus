import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/datasources/depreciation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/models/depreciation_report_models.dart';

class DepreciationReportRepository {
  final DepreciationReportRemoteDataSource ds;
  DepreciationReportRepository(this.ds);

  Future<DepreciationReportResult> getReport({
    String? dateFrom,
    String? dateTo,
  }) => ds.getReport(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportPdfUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportPdfUrl(dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportExcelUrl({String? dateFrom, String? dateTo}) =>
      ds.getExportExcelUrl(dateFrom: dateFrom, dateTo: dateTo);
}