import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';

class OvertimeRequestRemoteDataSource {
  final Dio dio;

  OvertimeRequestRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
  }) async {
    try {
      final r = await dio.get(
        '/hr/overtime-requests',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => OvertimeRequestModel.fromJson(e))
            .toList(),
        'meta': OvertimeRequestPaginationMeta(
          currentPage: pd['current_page'] ?? 1,
          lastPage: pd['last_page'] ?? 1,
          perPage: pd['per_page'] ?? 15,
          total: pd['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<OvertimeRequestDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/hr/overtime-requests/$enc');
      return OvertimeRequestDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<OvertimeRequestFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/hr/overtime-requests/form-options');
      return OvertimeRequestFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> create(OvertimeRequestFormModel f, {String actionType = 'save'}) async {
    try {
      final r = await dio.post(
        '/hr/overtime-requests',
        data: f.toJson(actionType: actionType),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    int id,
    OvertimeRequestFormModel f, {
    String actionType = 'save',
  }) async {
    try {
      final data = f.toJson(actionType: actionType);
      data['id_overtime_request'] = id;
      final r = await dio.put('/hr/overtime-requests/$id', data: data);
      return _extractEncryption(r.data) ?? f.encryption ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/hr/overtime-requests/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(int id, {double? approvedHours, String? notes}) async {
    try {
      await dio.post(
        '/hr/overtime-requests/$id/approve',
        data: {
          'approved_hours': approvedHours,
          if (notes != null) 'notes': notes,
        },
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id, {String? notes}) async {
    try {
      await dio.post('/hr/overtime-requests/$id/reject', data: {'notes': notes});
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
      final url = data['redirect_url']?.toString();
      if (url != null) return url.split('/').last;
    }
    return null;
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}