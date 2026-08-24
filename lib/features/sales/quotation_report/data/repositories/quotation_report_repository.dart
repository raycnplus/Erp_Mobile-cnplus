import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/datasources/quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/models/quotation_report_models.dart';

class QuotationReportRepository {
  final QuotationReportRemoteDataSource remoteDataSource;
  QuotationReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getQuotationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getQuotationReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() => remoteDataSource.getFormOptions();

  Future<List<QuotationLocationOption>> getLocationsByWarehouse(int idWarehouse) =>
      remoteDataSource.getLocationsByWarehouse(idWarehouse);
}