import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/repositories/billing_tax_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/models/billing_tax_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/datasources/billing_tax_report_remote_datasource.dart' show ExportUrlInfo;

class GetBillingTaxReport {
  final BillingTaxReportRepository r;
  GetBillingTaxReport(this.r);
  Future<BillingTaxResult> call({
    int? year,
    int? month,
    int? customerId,
    int page = 1,
    int perPage = 15,
  }) => r.getReport(year: year, month: month, customerId: customerId, page: page, perPage: perPage);
}

class GetBillingTaxFormOptions {
  final BillingTaxReportRepository r;
  GetBillingTaxFormOptions(this.r);
  Future<BillingTaxFormOptions> call() => r.getFormOptions();
}

class GetBillingTaxExportExcelUrl {
  final BillingTaxReportRepository r;
  GetBillingTaxExportExcelUrl(this.r);
  ExportUrlInfo call({int? year, int? month, int? customerId}) =>
      r.getExportExcelUrl(year: year, month: month, customerId: customerId);
}