import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/models/leave_type_models.dart';

class LeaveTypeRemoteDataSource {
  final Dio dio;
  LeaveTypeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getLeaveTypeList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get('/hr/leave-types', queryParameters: {'page': page, 'per_page': perPage});
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => LeaveTypeModel.fromJson(e)).toList(),
        'meta': LeaveTypePaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<LeaveTypeDetailModel> getLeaveTypeDetail(String encryption) async {
    try {
      final response = await dio.get('/hr/leave-types/$encryption');
      return LeaveTypeDetailModel.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<LeaveTypeFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('/hr/leave-types/form-options');
      return LeaveTypeFormOptions.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> createLeaveType(LeaveTypeFormModel formData) async {
    try { await dio.post('/hr/leave-types', data: formData.toJson()); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<String> updateLeaveType(String encryption, LeaveTypeFormModel formData) async {
    try {
      final response = await dio.put('/hr/leave-types/$encryption', data: formData.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> deleteLeaveType(String encryption) async {
    try { await dio.delete('/hr/leave-types/$encryption'); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}