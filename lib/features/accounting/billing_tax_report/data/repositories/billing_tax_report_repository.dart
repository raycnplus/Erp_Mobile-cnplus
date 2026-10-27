import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/datasources/billing_tax_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/models/billing_tax_report_models.dart';

class BillingTaxReportRepository {
  final BillingTaxReportRemoteDataSource ds;
  BillingTaxReportRepository(this.ds);

  Future<BillingTaxResult> getReport({
    int? year,
    int? month,
    int? customerId,
    int page = 1,
    int perPage = 15,
  }) => ds.getReport(year: year, month: month, customerId: customerId, page: page, perPage: perPage);

  Future<BillingTaxFormOptions> getFormOptions() => ds.getFormOptions();

  ExportUrlInfo getExportExcelUrl({int? year, int? month, int? customerId}) =>
      ds.getExportExcelUrl(year: year, month: month, customerId: customerId);
}