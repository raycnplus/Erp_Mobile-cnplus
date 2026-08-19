import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';

class StockCountRemoteDataSource {
  final Dio dio;
  static const _base = '/inventory/stock-counts';

  StockCountRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => StockCountModel.fromJson(e)).toList(),
        'meta': StockCountPaginationMeta(
          currentPage: _pi(pd['current_page']),
          lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']),
          total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StockCountDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return StockCountDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StockCountFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return StockCountFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> store(Map<String, dynamic> payload) async {
    try {
      final r = await dio.post(_base, data: payload);
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> update(int idStockOpname, Map<String, dynamic> payload) async {
    try {
      final r = await dio.put('$_base/$idStockOpname', data: payload);
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(String encryption, String reason) async {
    try {
      await dio.post('$_base/$encryption/cancel', data: {'cancel_reason': reason});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('$_base/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> storeCount({
    required int idStockOpname,
    required int idLocation,
    required List<SCFormItem> products,
    required String actionType,
  }) async {
    try {
      final r = await dio.post('$_base/store-count', data: {
        'id_stock_opname': idStockOpname,
        'id_location': idLocation,
        'action_type': actionType,
        'products': products.map((p) => p.toJson()).toList(),
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> loadProducts({
    int? warehouseId,
    int? locationId,
    int? idStockOpname,
  }) async {
    try {
      final r = await dio.get('$_base/load-products', queryParameters: {
        if (warehouseId != null) 'warehouse': warehouseId,
        if (locationId != null) 'location': locationId,
        if (idStockOpname != null) 'id_stock_opname': idStockOpname,
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<SCLocationOption>> getLocationsByWarehouse(int warehouseId) async {
    try {
      final r = await dio.get('$_base/locations-by-warehouse', queryParameters: {'warehouse': warehouseId});
      final list = (r.data['data'] as List? ?? r.data as List? ?? []);
      return list.map((e) => SCLocationOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> indexLocation(String encryption, String warehouseEncryption) async {
    try {
      final r = await dio.get('$_base/index-location', queryParameters: {
        'encryption': encryption,
        'warehouse_encryption': warehouseEncryption,
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('$_base/$id/steps');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(int id) async {
    try {
      await dio.post('$_base/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('$_base/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}