import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/datasources/ar_aging_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/models/ar_aging_report_models.dart';

class ARAgingReportRepository {
  final ARAgingReportRemoteDataSource ds;
  ARAgingReportRepository(this.ds);

  Future<ARAgingResult> getReport({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => ds.getReport(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);

  Future<ARAgingFormOptions> getFormOptions() => ds.getFormOptions();

  ExportUrlInfo getExportPdfUrl({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => ds.getExportPdfUrl(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);

  ExportUrlInfo getExportExcelUrl({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => ds.getExportExcelUrl(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);
}