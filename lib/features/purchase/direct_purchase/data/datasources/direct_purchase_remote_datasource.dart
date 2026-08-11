import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';

class DirectPurchaseRemoteDataSource {
  final Dio dio;

  DirectPurchaseRemoteDataSource(this.dio);

  static const String _base = '/purchase/direct-purchases';

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
        'items': (pd['data'] as List).map((e) => DirectPurchaseModel.fromJson(e)).toList(),
        'meta': DirectPurchasePaginationMeta(
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

  Future<DirectPurchaseDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return DirectPurchaseDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<DirectPurchaseFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return DirectPurchaseFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(DirectPurchaseFormModel f, String status, {double defaultTaxRate = 11.0}) async {
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
    DirectPurchaseFormModel f,
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

  Future<void> close(int id) async {
    try {
      await dio.post('$_base/$id/close');
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