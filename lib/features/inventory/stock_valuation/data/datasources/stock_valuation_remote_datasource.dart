import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class StockValuationRemoteDataSource {
  final Dio dio;
  StockValuationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getStockValuationList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? costingMethod,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/stock-valuation',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (costingMethod != null && costingMethod.isNotEmpty)
            'costing_method': costingMethod,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => StockValuationModel.fromJson(e)).toList(),
        'meta': StockValuationPaginationMeta.fromJson(paginator),
        'summary': StockValuationSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<StockValuationDetailModel> getStockValuationDetail(
    int idProduct,
  ) async {
    try {
      final response = await dio.get('/inventory/stock-valuation/$idProduct');
      return StockValuationDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<String>> getCostingMethods() async {
    try {
      final response = await dio.get('/inventory/stock-valuation/form-options');
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> methods = json['data']?['costing_methods'] ?? [];
      return methods.map((e) => '$e').toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}
