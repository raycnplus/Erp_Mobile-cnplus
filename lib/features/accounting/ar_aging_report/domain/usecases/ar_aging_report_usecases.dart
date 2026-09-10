import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/repositories/ar_aging_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/models/ar_aging_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/datasources/ar_aging_report_remote_datasource.dart' show ExportUrlInfo;

class GetARAgingReport {
  final ARAgingReportRepository r;
  GetARAgingReport(this.r);
  Future<ARAgingResult> call({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => r.getReport(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);
}

class GetARAgingFormOptions {
  final ARAgingReportRepository r;
  GetARAgingFormOptions(this.r);
  Future<ARAgingFormOptions> call() => r.getFormOptions();
}

class GetARAgingExportPdfUrl {
  final ARAgingReportRepository r;
  GetARAgingExportPdfUrl(this.r);
  ExportUrlInfo call({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => r.getExportPdfUrl(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);
}

class GetARAgingExportExcelUrl {
  final ARAgingReportRepository r;
  GetARAgingExportExcelUrl(this.r);
  ExportUrlInfo call({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => r.getExportExcelUrl(customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);
}