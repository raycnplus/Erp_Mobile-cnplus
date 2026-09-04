import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/datasources/service_quotation_report_remote_datasource.dart';

class ServiceQuotationReportRepository {
  final ServiceQuotationReportRemoteDataSource remoteDataSource;

  ServiceQuotationReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getServiceQuotationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) => remoteDataSource.getServiceQuotationReportList(
        page: page,
        perPage: perPage,
        search: search,
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();
}