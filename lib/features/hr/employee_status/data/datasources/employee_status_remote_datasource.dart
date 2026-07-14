import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';

class EmployeeStatusRemoteDataSource {
  final Dio dio;
  EmployeeStatusRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getStatusList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get('/hr/employee-statuses', queryParameters: {'page': page, 'per_page': perPage});
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => EmployeeStatusModel.fromJson(e)).toList(),
        'meta': EmployeeStatusPaginationMeta(currentPage: paginatedData['current_page'] ?? 1, lastPage: paginatedData['last_page'] ?? 1, perPage: paginatedData['per_page'] ?? 15, total: paginatedData['total'] ?? 0),
      };
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<EmployeeStatusDetailModel> getStatusDetail(String encryption) async {
    try {
      final response = await dio.get('/hr/employee-statuses/$encryption');
      return EmployeeStatusDetailModel.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> createStatus(EmployeeStatusFormModel formData) async {
    try { await dio.post('/hr/employee-statuses', data: formData.toJson()); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<String> updateStatus(String encryption, EmployeeStatusFormModel formData) async {
    try {
      final response = await dio.put('/hr/employee-statuses/$encryption', data: formData.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> deleteStatus(String encryption) async {
    try { await dio.delete('/hr/employee-statuses/$encryption'); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}