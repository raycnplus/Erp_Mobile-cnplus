import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';

class OvertimeTypeRemoteDataSource {
  final Dio dio;

  OvertimeTypeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/hr/overtime-types',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final paginationData = json['data'] as Map<String, dynamic>;

      return {
        'items': (paginationData['data'] as List)
            .map((item) => OvertimeTypeModel.fromJson(item))
            .toList(),
        'meta': OvertimeTypePaginationMeta(
          currentPage: paginationData['current_page'] ?? 1,
          lastPage: paginationData['last_page'] ?? 1,
          perPage: paginationData['per_page'] ?? 15,
          total: paginationData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<OvertimeTypeDetailModel> getDetail(String encryption) async {
    try {
      final response = await dio.get(
        '/hr/overtime-types/$encryption',
      );

      return OvertimeTypeDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<List<OvertimeCategoryOption>> getFormOptions() async {
    try {
      final response = await dio.get(
        '/hr/overtime-types/form-options',
      );

      final categories =
          response.data['data']['categories'] as List;

      return categories
          .map((item) => OvertimeCategoryOption.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<String> create(
    OvertimeTypeFormModel form,
  ) async {
    try {
      final response = await dio.post(
        '/hr/overtime-types',
        data: form.toJson(),
      );

      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<String> update(
    String encryption,
    OvertimeTypeFormModel form,
  ) async {
    try {
      final response = await dio.put(
        '/hr/overtime-types/$encryption',
        data: form.toJson(),
      );

      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete(
        '/hr/overtime-types/$encryption',
      );
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  String _getErrorMessage(DioException e) {
    return e.response?.data?['message'] ??
        e.response?.data?.toString() ??
        'Network error';
  }
}