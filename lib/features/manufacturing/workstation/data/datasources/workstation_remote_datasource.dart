import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';

class WorkstationRemoteDataSource {
  final Dio dio;

  WorkstationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get(
        '/manufacturing/workstations',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final items = paginatedData['data'] as List<dynamic>? ?? [];
      return {
        'items': items.map((e) => WorkstationModel.fromJson(e)).toList(),
        'meta': WorkstationPaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<WorkstationDetailModel> getDetail(String encryption) async {
    try {
      final response = await dio.get('/manufacturing/workstations/$encryption');
      return WorkstationDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(WorkstationFormModel f) async {
    try {
      await dio.post('/manufacturing/workstations', data: f.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String encryption, WorkstationFormModel f) async {
    try {
      final response = await dio.put(
        '/manufacturing/workstations/$encryption',
        data: f.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete('/manufacturing/workstations/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data['message'] ?? 'Network error: ${e.message}';
}