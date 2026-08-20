import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/models/stock_movement_models.dart';

class StockMovementRemoteDataSource {
  final Dio dio;
  StockMovementRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getStockMovementList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/stock-movements',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => StockMovementModel.fromJson(e)).toList(),
        'meta': StockMovementPaginationMeta.fromJson(paginator),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<StockMovementFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('/inventory/stock-movements/form-options');
      return StockMovementFormOptions.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<LocationOptionModel>> getLocationsByWarehouse(
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '/inventory/stock-movements/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => LocationOptionModel.fromJson(e)).toList();
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
