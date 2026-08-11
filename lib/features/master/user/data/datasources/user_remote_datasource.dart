import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/models/user_models.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/users',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final json = response.data as Map<String, dynamic>;

      return {
        'items': (json['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList(),
        'meta': UserPaginationMeta(
          currentPage: json['current_page'] ?? 1,
          lastPage: json['last_page'] ?? 1,
          perPage: json['per_page'] ?? 15,
          total: json['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<UserDetailModel> getDetail(int id) async {
    try {
      final response = await dio.get('/master/users/$id');
      return UserDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> toggleStatus(int id) async {
    try {
      final response = await dio.patch(
        '/master/users/$id/toggle-status',
      );

      return response.data['status'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/master/users/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) {
    return e.response?.data?['message'] ??
        e.response?.data?.toString() ??
        'Network error';
  }
}