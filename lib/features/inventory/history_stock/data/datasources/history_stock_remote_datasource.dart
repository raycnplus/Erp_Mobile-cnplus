import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';

class HistoryStockRemoteDataSource {
  final Dio dio;
  HistoryStockRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getHistoryStockList({
    int page = 1,
    int perPage = 100,
    String? date,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/history-stock-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (date != null && date.isNotEmpty) 'date': date,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (idProduct != null) 'id_product': idProduct,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => HistoryStockModel.fromJson(e)).toList(),
        'meta': HistoryStockPaginationMeta.fromJson(paginator),
        'summary': HistoryStockSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? idProduct,
    String? date,
    String? movementType,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/history-stock-report/transactions',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (idProduct != null) 'id_product': idProduct,
          if (date != null && date.isNotEmpty) 'date': date,
          if (movementType != null && movementType.isNotEmpty)
            'movement_type': movementType,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => HistoryTransactionModel.fromJson(e)).toList(),
        'meta': HistoryStockPaginationMeta.fromJson(paginator),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get(
        '/inventory/history-stock-report/form-options',
      );
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'warehouses': ((data['warehouses'] ?? []) as List)
            .map((e) => HistoryWarehouseOption.fromJson(e))
            .toList(),
        'products': ((data['products'] ?? []) as List)
            .map((e) => HistoryProductOption.fromJson(e))
            .toList(),
        'today': data['today'] ?? '',
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<HistoryLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '/inventory/history-stock-report/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => HistoryLocationOption.fromJson(e)).toList();
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
