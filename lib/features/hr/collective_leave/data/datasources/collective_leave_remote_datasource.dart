import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';

class CollectiveLeaveRemoteDataSource {
  final Dio dio;

  CollectiveLeaveRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getCollectiveLeaveList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/hr/collective-leaves',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final items = List<dynamic>.from(data['data'] ?? []);

      return {
        'items': items
            .map((item) => CollectiveLeaveModel.fromJson(item))
            .toList(),
        'meta': CollectiveLeavePaginationMeta(
          currentPage: data['current_page'] ?? 1,
          lastPage: data['last_page'] ?? 1,
          perPage: data['per_page'] ?? 15,
          total: data['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<CollectiveLeaveDetailModel> getCollectiveLeaveDetail(
    String encryption,
  ) async {
    try {
      final response = await dio.get(
        '/hr/collective-leaves/$encryption',
      );

      return CollectiveLeaveDetailModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<void> createCollectiveLeave(
    CollectiveLeaveFormModel formData,
  ) async {
    try {
      await dio.post(
        '/hr/collective-leaves',
        data: formData.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<String> updateCollectiveLeave(
    String encryption,
    CollectiveLeaveFormModel formData,
  ) async {
    try {
      final response = await dio.put(
        '/hr/collective-leaves/$encryption',
        data: formData.toJson(),
      );

      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<void> deleteCollectiveLeave(
    String encryption,
  ) async {
    try {
      await dio.delete(
        '/hr/collective-leaves/$encryption',
      );
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  String _errorMessage(DioException e) {
    return e.response?.data['message'] ??
        'Network error: ${e.message}';
  }
}