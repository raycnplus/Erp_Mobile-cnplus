import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';

class PurchaseOrderRemoteDataSource {
  final Dio dio;

  PurchaseOrderRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/purchase/purchase-orders',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => PurchaseOrderModel.fromJson(e)).toList(),
        'meta': PurchaseOrderPaginationMeta(
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

  Future<PurchaseOrderDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/purchase/purchase-orders/$enc');
      return PurchaseOrderDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PurchaseOrderFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/purchase/purchase-orders/form-options');
      return PurchaseOrderFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(PurchaseOrderFormModel f, String status, {double defaultTaxRate = 11.0}) async {
    try {
      final r = await dio.post(
        '/purchase/purchase-orders',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    PurchaseOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.put(
        '/purchase/purchase-orders/$enc',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(int id, String reason) async {
    try {
      await dio.post('/purchase/purchase-orders/$id/cancel', data: {'cancel_reason': reason});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> close(int id) async {
    try {
      await dio.post('/purchase/purchase-orders/$id/close');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/purchase/purchase-orders/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createBillFromPurchaseOrder(int id) async {
    try {
      final r = await dio.post('/purchase/purchase-orders/$id/create-bill');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createBillFromTerm(int poId, int scheduleId) async {
    try {
      final r = await dio.post('/purchase/purchase-orders/$poId/create-bill-term/$scheduleId');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double> getLastPrices(int idVendor, int idProduct) async {
    try {
      final r = await dio.get(
        '/purchase/purchase-orders/last-prices',
        queryParameters: {'id_vendor': idVendor, 'id_product': idProduct},
      );
      return _pd(r.data['last_price']);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double?> getPriceFromList(int productId, int priceListId) async {
    try {
      final r = await dio.get(
        '/purchase/purchase-orders/price-from-list',
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

  Future<void> approve(int id) async {
    try {
      await dio.post('/purchase/purchase-orders/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('/purchase/purchase-orders/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('/purchase/purchase-orders/$id/steps');
      return r.data as Map<String, dynamic>;
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

  double _pd(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}