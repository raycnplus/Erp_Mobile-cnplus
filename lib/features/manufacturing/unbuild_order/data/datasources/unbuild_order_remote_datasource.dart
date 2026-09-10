import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';

class UnbuildOrderRemoteDataSource {
  final Dio dio;

  UnbuildOrderRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/manufacturing/unbuild-orders',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => UnbuildOrderModel.fromJson(e)).toList(),
        'meta': UOPaginationMeta(
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

  Future<UnbuildOrderDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/manufacturing/unbuild-orders/$enc');
      return UnbuildOrderDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<UnbuildOrderFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/manufacturing/unbuild-orders/form-options');
      return UnbuildOrderFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> generateReference() async {
    try {
      final r = await dio.get('/manufacturing/unbuild-orders/generate-reference');
      return r.data['reference']?.toString() ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<UOPreviewComponent>> getComponentsPreview(List<UOPreviewRequestItem> items) async {
    try {
      final r = await dio.post(
        '/manufacturing/unbuild-orders/components-preview',
        data: {'unbuild_products': items.map((e) => e.toJson()).toList()},
      );
      return (r.data['components'] as List? ?? [])
          .map((e) => UOPreviewComponent.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<UOManufacturingOrderDetails> getManufacturingOrderDetails(int moId) async {
    try {
      final r = await dio.get('/manufacturing/unbuild-orders/mo-details/$moId');
      return UOManufacturingOrderDetails.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(UnbuildOrderFormModel f, String status) async {
    try {
      final r = await dio.post('/manufacturing/unbuild-orders', data: f.toJson(status));
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String enc, UnbuildOrderFormModel f, String status) async {
    try {
      final r = await dio.put('/manufacturing/unbuild-orders/$enc', data: f.toJson(status));
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/manufacturing/unbuild-orders/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(String enc) async {
    try {
      await dio.post('/manufacturing/unbuild-orders/$enc/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(String enc) async {
    try {
      await dio.post('/manufacturing/unbuild-orders/$enc/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(String enc) async {
    try {
      final r = await dio.get('/manufacturing/unbuild-orders/$enc/steps');
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

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}