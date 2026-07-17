import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/models/uom_models.dart';

class UomRemoteDataSource {
  final Dio dio;

  UomRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/unit-of-measures',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final json = response.data as Map<String, dynamic>;

      return {
        'items': (json['data'] as List)
            .map((e) => UomModel.fromJson(e))
            .toList(),
        'meta': UomPaginationMeta(
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

  Future<UomDetailModel> getDetail(String enc) async {
    try {
      final response = await dio.get('/master/unit-of-measures/$enc');

      return UomDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<UomRefOption>> getFormOptions() async {
    try {
      final response = await dio.get('/master/unit-of-measures/form-options');

      final data = response.data['data'] as List;

      return data
          .map((e) => UomRefOption.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(UomFormModel form) async {
    try {
      await dio.post(
        '/master/unit-of-measures',
        data: form.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    UomFormModel form,
  ) async {
    try {
      final response = await dio.put(
        '/master/unit-of-measures/$enc',
        data: form.toJson(),
      );

      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/master/unit-of-measures/$enc');
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