import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';

class PurchaseRequestRemoteDataSource {
  final Dio dio;

  PurchaseRequestRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/purchase/purchase-requests',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) {
          return PurchaseRequestModel.fromJson(e);
        }).toList(),
        'meta': PurchaseRequestPaginationMeta(
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

  Future<PurchaseRequestDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/purchase/purchase-requests/$enc');
      return PurchaseRequestDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PurchaseRequestFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/purchase/purchase-requests/form-options');
      return PurchaseRequestFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(PurchaseRequestFormModel f, String status) async {
    try {
      final r = await dio.post(
        '/purchase/purchase-requests',
        data: f.toJson(status),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String enc, PurchaseRequestFormModel f, String status) async {
    try {
      final r = await dio.put(
        '/purchase/purchase-requests/$enc',
        data: f.toJson(status),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(int id, String reason) async {
    try {
      await dio.post(
        '/purchase/purchase-requests/$id/cancel',
        data: {'cancel_reason': reason},
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/purchase/purchase-requests/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createRfq(int id) async {
    try {
      final r = await dio.post('/purchase/purchase-requests/$id/create-rfq');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createDp(int id) async {
    try {
      final r = await dio.post('/purchase/purchase-requests/$id/create-dp');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(int id) async {
    try {
      await dio.post('/purchase/purchase-requests/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('/purchase/purchase-requests/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('/purchase/purchase-requests/$id/steps');
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

  String _err(DioException e) {
    return e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
  }

  int _pi(dynamic v) {
    if (v == null) {
      return 0;
    }
    if (v is int) {
      return v;
    }
    return int.tryParse(v.toString()) ?? 0;
  }
}