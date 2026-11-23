import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/repositories/direct_sales_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/models/direct_sales_report_models.dart';

class GetDirectSalesReportList {
  final DirectSalesReportRepository repository;

  GetDirectSalesReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getDirectSalesReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetDirectSalesReportFormOptions {
  final DirectSalesReportRepository repository;

  GetDirectSalesReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class GetDirectSalesReportLocationsByWarehouse {
  final DirectSalesReportRepository repository;

  GetDirectSalesReportLocationsByWarehouse(this.repository);

  Future<List<DirectSalesLocationOption>> call(int idWarehouse) =>
      repository.getLocationsByWarehouse(idWarehouse);
}

class GetDirectSalesReportExportPdfUrl {
  final DirectSalesReportRepository repository;

  GetDirectSalesReportExportPdfUrl(this.repository);

  DirectSalesReportExportUrlInfo call({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportPdfUrl(
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}

class GetDirectSalesReportExportExcelUrl {
  final DirectSalesReportRepository repository;

  GetDirectSalesReportExportExcelUrl(this.repository);

  DirectSalesReportExportUrlInfo call({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => repository.getExportExcelUrl(
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
}