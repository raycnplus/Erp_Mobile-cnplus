import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/models/invoice_report_models.dart';

class InvoiceReportRemoteDataSource {
  final Dio dio;

  InvoiceReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getInvoiceReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? sourceType,
    int? salesPerson,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        '/invoice-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (sourceType != null && sourceType.isNotEmpty) 'source_type': sourceType,
          if (salesPerson != null) 'sales_person': salesPerson,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => InvoiceReportModel.fromJson(e)).toList(),
        'meta': InvoiceReportPaginationMeta.fromJson(paginator),
        'summary': InvoiceReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/invoice-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'salespersons': ((data['salespersons'] ?? []) as List)
            .map((e) => InvoiceSalesPersonOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
        'sourceTypes': ((data['source_types'] ?? []) as List)
            .map((e) => InvoiceSourceTypeOption.fromJson(e))
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