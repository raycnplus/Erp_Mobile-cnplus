import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/models/sales_product_report_models.dart';

class SalesProductReportRemoteDataSource {
  final Dio dio;
  SalesProductReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getSalesProductReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idProduct,
    int? idCategory,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await dio.get(
        '/sales/sales-product-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idProduct != null) 'id_product': idProduct,
          if (idCategory != null) 'id_category': idCategory,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => SalesProductReportModel.fromJson(e)).toList(),
        'meta': SalesProductReportPaginationMeta.fromJson(paginator),
        'summary': SalesProductReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/sales/sales-product-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'products': ((data['products'] ?? []) as List)
            .map((e) => SalesProductOption.fromJson(e))
            .toList(),
        'categories': ((data['categories'] ?? []) as List)
            .map((e) => SalesProductCategoryOption.fromJson(e))
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