import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';

class WorkOrderRemoteDataSource {
  final Dio dio;

  WorkOrderRemoteDataSource(this.dio);

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 15,
    WorkOrderFilter? filter,
  }) async {
    try {
      final r = await dio.get(
        '/manufacturing/work-orders',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (filter?.workstationId != null) 'workstation_id': filter!.workstationId,
          if (filter?.status != null && filter!.status!.isNotEmpty) 'status': filter.status,
          if (filter?.moReference != null && filter!.moReference!.isNotEmpty) 'mo_reference': filter.moReference,
          if (filter?.productId != null) 'product_id': filter!.productId,
          if (filter?.dateFrom != null) 'date_from': _fmtDate(filter!.dateFrom!),
          if (filter?.dateTo != null) 'date_to': _fmtDate(filter!.dateTo!),
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => WorkOrderModel.fromJson(e)).toList(),
        'meta': WOPaginationMeta(
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

  Future<WorkOrderFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/manufacturing/work-orders/form-options');
      return WorkOrderFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> start(int id) async {
    try {
      final r = await dio.post('/manufacturing/work-orders/$id/start');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> pause(int id) async {
    try {
      final r = await dio.post('/manufacturing/work-orders/$id/pause');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> resume(int id) async {
    try {
      final r = await dio.post('/manufacturing/work-orders/$id/resume');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> complete(int id) async {
    try {
      final r = await dio.post('/manufacturing/work-orders/$id/complete');
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