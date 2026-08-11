import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';

class DeliveryNoteRemoteDataSource {
  final Dio dio;
  static const _base = '/inventory/delivery-notes';

  DeliveryNoteRemoteDataSource(this.dio);

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
        'items': (pd['data'] as List).map((e) => DeliveryNoteModel.fromJson(e)).toList(),
        'meta': DeliveryNotePaginationMeta(
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

  Future<DeliveryNoteDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return DeliveryNoteDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<DeliveryNoteFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return DeliveryNoteFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  /// Creates a new Draft. Only used for the initial 'save' with no id yet.
  Future<Map<String, dynamic>> store(DeliveryNoteFormModel f, String status) async {
    try {
      final r = await dio.post(_base, data: f.toJson(status));
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  /// Used for save (edit draft), confirm, and validate — all keyed by encryption + status.
  Future<Map<String, dynamic>> update(String encryption, DeliveryNoteFormModel f, String status) async {
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
    required int idDeliveryNoteItem,
    required double deliveredQty,
    List<Map<String, dynamic>>? trackingData,
  }) async {
    try {
      final r = await dio.post('$_base/save-tracking', data: {
        'id_delivery_note_item': idDeliveryNoteItem,
        'delivered_qty': deliveredQty,
        'tracking_data': trackingData,
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByLocation(int locationId) async {
    try {
      final r = await dio.get('$_base/products-by-location', queryParameters: {'id_location': locationId});
      return (r.data['products'] as List? ?? []).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double> checkStock(int productId, int locationId) async {
    try {
      final r = await dio.get('$_base/check-stock', queryParameters: {
        'id_product': productId,
        'id_location': locationId,
      });
      return double.tryParse(r.data['stock_qty']?.toString() ?? '0') ?? 0;
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

  Future<Map<String, dynamic>> getLotSerialsSorted(int productId, int locationId) async {
    try {
      final r = await dio.get('$_base/lot-serials-sorted', queryParameters: {
        'id_product': productId,
        'id_location': locationId,
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createReturn(String encryption) async {
    try {
      final r = await dio.post('$_base/$encryption/create-return');
      return r.data as Map<String, dynamic>;
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