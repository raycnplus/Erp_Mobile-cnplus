import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';

class LeaveRequestRemoteDataSource {
  final Dio dio;

  LeaveRequestRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
  }) async {
    try {
      final r = await dio.get(
        '/hr/leave-requests',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => LeaveRequestModel.fromJson(e))
            .toList(),
        'meta': LeaveRequestPaginationMeta(
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

  Future<LeaveRequestDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/hr/leave-requests/$enc');
      return LeaveRequestDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<LeaveRequestFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/hr/leave-requests/form-options');
      return LeaveRequestFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> create(LeaveRequestFormModel f, {String status = 'save'}) async {
    try {
      final r = await dio.post('/hr/leave-requests', data: f.toJson(status: status));
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    int idLeaveRequest,
    LeaveRequestFormModel f, {
    String status = 'save',
  }) async {
    try {
      final data = f.toJson(status: status);
      data['id_leave_request'] = idLeaveRequest;
      final r = await dio.put('/hr/leave-requests/$idLeaveRequest', data: data);
      return _extractEncryption(r.data) ?? f.encryption ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/hr/leave-requests/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(int id) async {
    try {
      await dio.post('/hr/leave-requests/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id, {String? notes}) async {
    try {
      await dio.post('/hr/leave-requests/$id/reject', data: {'notes': notes});
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
      final redirectUrl = data['redirect_url']?.toString();
      if (redirectUrl != null) {
        final parts = redirectUrl.split('/');
        return parts.isNotEmpty ? parts.last : null;
      }
    }
    return null;
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}