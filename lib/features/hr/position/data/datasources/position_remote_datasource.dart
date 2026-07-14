import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/models/position_models.dart';

class PositionRemoteDataSource {
  final Dio dio;
  PositionRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPositionList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get('/hr/positions', queryParameters: {'page': page, 'per_page': perPage});
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => PositionModel.fromJson(e)).toList(),
        'meta': PositionPaginationMeta(currentPage: paginatedData['current_page'] ?? 1, lastPage: paginatedData['last_page'] ?? 1, perPage: paginatedData['per_page'] ?? 15, total: paginatedData['total'] ?? 0),
      };
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<PositionDetailModel> getPositionDetail(String encryption) async {
    try {
      final response = await dio.get('/hr/positions/$encryption');
      return PositionDetailModel.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> createPosition(PositionFormModel formData) async {
    try { await dio.post('/hr/positions', data: formData.toJson()); } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<String> updatePosition(String encryption, PositionFormModel formData) async {
    try {
      final response = await dio.put('/hr/positions/$encryption', data: formData.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> deletePosition(String encryption) async {
    try { await dio.delete('/hr/positions/$encryption'); } on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}