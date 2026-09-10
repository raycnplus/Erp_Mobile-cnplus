import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/models/return_dn_models.dart';

class ReturnDNRemoteDataSource {
  final Dio dio;
  static const _base = '/inventory/return-delivery-notes';

  ReturnDNRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page, 'per_page': perPage,
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => ReturnDNModel.fromJson(e)).toList(),
        'meta': ReturnDNPaginationMeta(
          currentPage: _pi(pd['current_page']), lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']), total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ReturnDNDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return ReturnDNDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ReturnDNFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return ReturnDNFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<DNOption>> getValidatedDNs({int? excludeReturnDeliveryNoteId}) async {
    try {
      final r = await dio.get('$_base/validated-dns', queryParameters: {
        if (excludeReturnDeliveryNoteId != null) 'id_return_delivery_note': excludeReturnDeliveryNoteId,
      });
      final list = (r.data['data'] as List? ?? []);
      return list.map((e) => DNOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<DNOption>> getDNBySO(int soId) async {
    try {
      final r = await dio.get('$_base/dn-by-so', queryParameters: {'so_id': soId});
      final list = (r.data['dns'] as List? ?? []);
      return list.map((e) => DNOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<ReturnDNItem>> getItemsByDN(List<int> dnIds) async {
    try {
      final r = await dio.get(
        '$_base/items-by-dn',
        queryParameters: {'dn_ids[]': dnIds},
      );
      final list = (r.data['items'] as List? ?? []);
      return list.map((e) => ReturnDNItem.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ReplaceProductsResult> getReplaceProducts(int idDeliveryNote) async {
    try {
      final r = await dio.get('$_base/replace-products', queryParameters: {'id_delivery_note': idDeliveryNote});
      return ReplaceProductsResult.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double> getReplaceProductStock({required int idProduct, required int idDeliveryNote}) async {
    try {
      final r = await dio.get('$_base/replace-product-stock', queryParameters: {
        'id_product': idProduct,
        'id_delivery_note': idDeliveryNote,
      });
      final v = r.data['on_hand'];
      return v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> store(ReturnDNFormModel f, String status) async {
    try {
      final r = await dio.post(_base, data: f.toJson(status));
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> update(String encryption, ReturnDNFormModel f, String status) async {
    try {
      final r = await dio.put('$_base/$encryption', data: f.toJson(status));
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

  Future<Map<String, dynamic>> saveTracking({
    required int idReturnDeliveryNoteItem,
    List<Map<String, dynamic>>? trackingData,
  }) async {
    try {
      final r = await dio.post('$_base/save-tracking', data: {
        'id_return_delivery_note_item': idReturnDeliveryNoteItem,
        'tracking_data': trackingData,
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

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}