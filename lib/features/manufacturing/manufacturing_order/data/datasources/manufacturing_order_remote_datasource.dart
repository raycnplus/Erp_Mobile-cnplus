import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';

class ManufacturingOrderRemoteDataSource {
  final Dio dio;

  ManufacturingOrderRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/manufacturing/manufacturing-order',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => ManufacturingOrderModel.fromJson(e)).toList(),
        'meta': MOPaginationMeta(
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

  Future<ManufacturingOrderDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/manufacturing/manufacturing-order/$enc');
      return ManufacturingOrderDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ManufacturingOrderFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/manufacturing/manufacturing-order/form-options');
      return ManufacturingOrderFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<MOProductBomsResult> getProductBoms(int productId) async {
    try {
      final r = await dio.get(
        '/manufacturing/manufacturing-order/product-boms',
        queryParameters: {'id_product': productId},
      );
      return MOProductBomsResult.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<MOBomDetail?> getBomDetails(int bomId) async {
    try {
      final r = await dio.get(
        '/manufacturing/manufacturing-order/bom-details',
        queryParameters: {'id_bom': bomId},
      );
      if (r.data['success'] != true || r.data['bom'] == null) return null;
      return MOBomDetail.fromJson(r.data['bom']);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<MOBomComponent>> getBomComponents(int bomId, {double qty = 1}) async {
    try {
      final r = await dio.get(
        '/manufacturing/manufacturing-order/bom-components',
        queryParameters: {'id_bom': bomId, 'qty': qty},
      );
      return (r.data['components'] as List? ?? [])
          .map((e) => MOBomComponent.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<MOPlanMaterial>> getPlanMaterials({
    required int bomId,
    double qty = 1,
    required int warehouseId,
    required int locationId,
    int? manufacturingOrderId,
  }) async {
    try {
      final r = await dio.get(
        '/manufacturing/manufacturing-order/plan-materials',
        queryParameters: {
          'bom_id': bomId,
          'qty': qty,
          'warehouse_id': warehouseId,
          'location_id': locationId,
          if (manufacturingOrderId != null) 'manufacturing_order_id': manufacturingOrderId,
        },
      );
      return (r.data['components'] as List? ?? [])
          .map((e) => MOPlanMaterial.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(ManufacturingOrderFormModel f, String status) async {
    try {
      final r = await dio.post(
        '/manufacturing/manufacturing-order',
        data: f.toJson(status),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String enc, ManufacturingOrderFormModel f, String status) async {
    try {
      final r = await dio.put(
        '/manufacturing/manufacturing-order/$enc',
        data: f.toJson(status),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/manufacturing/manufacturing-order/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(String enc) async {
    try {
      await dio.post('/manufacturing/manufacturing-order/$enc/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(String enc) async {
    try {
      await dio.post('/manufacturing/manufacturing-order/$enc/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(String enc) async {
    try {
      final r = await dio.get('/manufacturing/manufacturing-order/$enc/steps');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<MOCreateUnbuildResult> createUnbuild(String enc) async {
    try {
      final r = await dio.post('/manufacturing/manufacturing-order/$enc/create-unbuild');
      final data = r.data as Map<String, dynamic>;
      return MOCreateUnbuildResult.fromJson(data['data'] ?? data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> startOperation(int moId, int bomOperationId) async {
    try {
      final r = await dio.post(
        '/manufacturing/manufacturing-order/operations/start',
        data: {
          'id_manufacturing_order': moId,
          'id_bom_operation': bomOperationId,
        },
      );
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> pauseOperation(int trackingId) async {
    try {
      final r = await dio.post(
        '/manufacturing/manufacturing-order/operations/pause',
        data: {'id_mo_operation_tracking': trackingId},
      );
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> resumeOperation(int trackingId) async {
    try {
      final r = await dio.post(
        '/manufacturing/manufacturing-order/operations/resume',
        data: {'id_mo_operation_tracking': trackingId},
      );
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> completeOperation(int trackingId) async {
    try {
      final r = await dio.post(
        '/manufacturing/manufacturing-order/operations/complete',
        data: {'id_mo_operation_tracking': trackingId},
      );
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