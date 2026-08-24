import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class StockValuationRemoteDataSource {
  final Dio dio;
  StockValuationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getWarehouseList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? branch,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/stock-valuation',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (branch != null && branch.isNotEmpty) 'branch': branch,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => StockValuationWarehouseModel.fromJson(e)).toList(),
        'meta': StockValuationPaginationMeta.fromJson(paginator),
        'grandTotalValuationRaw': '${json['summary']?['grand_total_valuation'] ?? 0}',
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<StockValuationDetailModel> getWarehouseDetail(
    int idWarehouse, {
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/stock-valuation/$idWarehouse',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      return StockValuationDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<String>> getBranches() async {
    try {
      final response = await dio.get('/inventory/stock-valuation/form-options');
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> branches = json['data']?['branches'] ?? [];
      return branches.map((e) => '$e').toList();
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