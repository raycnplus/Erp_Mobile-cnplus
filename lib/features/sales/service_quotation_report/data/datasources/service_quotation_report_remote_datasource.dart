import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/models/service_quotation_report_models.dart';

class ServiceQuotationReportRemoteDataSource {
  final Dio dio;

  ServiceQuotationReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getServiceQuotationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        '/sales/service/quotation-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (customerId != null) 'customer_id': customerId,
          if (salesId != null) 'sales_id': salesId,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => ServiceQuotationReportModel.fromJson(e)).toList(),
        'meta': ServiceQuotationReportPaginationMeta.fromJson(paginator),
        'summary': ServiceQuotationReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/sales/service/quotation-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'customers': ((data['customers'] ?? []) as List)
            .map((e) => ServiceQuotationCustomerOption.fromJson(e))
            .toList(),
        'salespersons': ((data['salespersons'] ?? []) as List)
            .map((e) => ServiceQuotationSalesPersonOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}