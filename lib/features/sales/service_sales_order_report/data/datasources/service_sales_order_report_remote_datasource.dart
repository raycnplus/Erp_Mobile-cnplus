import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/models/service_sales_order_report_models.dart';

class ServiceSalesOrderReportRemoteDataSource {
  final Dio dio;

  ServiceSalesOrderReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getServiceSalesOrderReportList({
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
        '/service/sales-order-report',
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
        'items': items.map((e) => ServiceSalesOrderReportModel.fromJson(e)).toList(),
        'meta': ServiceSalesOrderReportPaginationMeta.fromJson(paginator),
        'summary': ServiceSalesOrderReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/service/sales-order-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'customers': ((data['customers'] ?? []) as List)
            .map((e) => ServiceSalesOrderCustomerOption.fromJson(e))
            .toList(),
        'salespersons': ((data['salespersons'] ?? []) as List)
            .map((e) => ServiceSalesOrderSalesPersonOption.fromJson(e))
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