import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';

class DepartmentRemoteDataSource {
  final Dio dio;
  DepartmentRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getDepartmentList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get('/hr/departments', queryParameters: {'page': page, 'per_page': perPage});
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => DepartmentModel.fromJson(e)).toList(),
        'meta': DepartmentPaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<DepartmentDetailModel> getDepartmentDetail(String encryption) async {
    try {
      final response = await dio.get('/hr/departments/$encryption');
      return DepartmentDetailModel.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> createDepartment(DepartmentFormModel formData) async {
    try { await dio.post('/hr/departments', data: formData.toJson()); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<String> updateDepartment(String encryption, DepartmentFormModel formData) async {
    try {
      final response = await dio.put(
        '/hr/departments/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> deleteDepartment(String encryption) async {
    try { await dio.delete('/hr/departments/$encryption'); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}