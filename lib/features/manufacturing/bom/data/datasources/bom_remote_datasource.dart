import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';

class BomRemoteDataSource {
  final Dio dio;

  BomRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/manufacturing/bill-of-materials',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final items = paginatedData['data'] as List<dynamic>? ?? [];
      return {
        'items': items.map((e) => BomModel.fromJson(e)).toList(),
        'meta': BomPaginationMeta(
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

  Future<BomDetailModel> getDetail(String encryption) async {
    try {
      final response = await dio.get('/manufacturing/bill-of-materials/$encryption');
      return BomDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BomFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('/manufacturing/bill-of-materials/form-options');
      return BomFormOptions.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(BomFormModel form) async {
    try {
      await dio.post('/manufacturing/bill-of-materials', data: form.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String encryption, BomFormModel form) async {
    try {
      final response = await dio.put(
        '/manufacturing/bill-of-materials/$encryption',
        data: form.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete('/manufacturing/bill-of-materials/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data['message'] ?? 'Network error: ${e.message}';
}