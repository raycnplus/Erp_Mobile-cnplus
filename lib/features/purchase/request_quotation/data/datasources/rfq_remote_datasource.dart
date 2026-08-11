import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/models/rfq_models.dart';

class RfqRemoteDataSource {
  final Dio dio;

  RfqRemoteDataSource(this.dio);

  static const String _base = '/purchase/rfqs';

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        _base,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => RfqModel.fromJson(e)).toList(),
        'meta': RfqPaginationMeta(
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

  Future<RfqDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return RfqDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<RfqFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return RfqFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(RfqFormModel f, String status, {double defaultTaxRate = 11.0}) async {
    try {
      final r = await dio.post(
        _base,
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    RfqFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.put(
        '$_base/$enc',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(int id, String reason) async {
    try {
      await dio.post('$_base/$id/cancel', data: {'cancel_reason': reason});
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

  Future<Map<String, dynamic>> createPO(int id) async {
    try {
      final r = await dio.post('$_base/$id/create-po');
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

  Future<double?> getPriceFromList(int productId, int priceListId) async {
    try {
      final r = await dio.get(
        '$_base/price-from-list',
        queryParameters: {'id_product': productId, 'id_price_list': priceListId},
      );
      if (r.data['success'] == true && r.data['custom_price'] != null) {
        return double.tryParse(r.data['custom_price'].toString());
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<List<RfqLocationOption>> getLocationsByWarehouse(int warehouseId) async {
    try {
      final r = await dio.get('$_base/locations-by-warehouse/$warehouseId');
      return (r.data['data'] as List? ?? [])
          .map((e) => RfqLocationOption.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String? _extractEncryption(dynamic data) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map && inner['encryption'] != null) {
        return inner['encryption'].toString();
      }
    }
    return null;
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}