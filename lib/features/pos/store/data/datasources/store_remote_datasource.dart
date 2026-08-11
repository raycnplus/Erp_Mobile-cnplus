import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';

class StoreRemoteDataSource {
  final Dio dio;

  StoreRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/pos/stores-mobile',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty)
            'search': search,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;

      return {
        'items': (paginator['data'] as List)
            .map((e) => StoreModel.fromJson(e))
            .toList(),
        'meta': StorePaginationMeta(
          currentPage: paginator['current_page'] ?? 1,
          lastPage: paginator['last_page'] ?? 1,
          perPage: paginator['per_page'] ?? 15,
          total: paginator['total'] ?? 0,
        ),
        'pos_require_pin': json['pos_require_pin'] ?? false,
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreDetailModel> getDetail(String enc) async {
    try {
      final response = await dio.get(
        '/pos/stores-mobile/$enc',
      );

      return StoreDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreFormOptions> getFormOptions() async {
    try {
      final response = await dio.get(
        '/pos/stores-mobile/form-options',
      );

      return StoreFormOptions.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreModel> create(StoreFormModel form) async {
    try {
      final response = await dio.post(
        '/pos/stores-mobile',
        data: form.toJson(),
      );

      return StoreModel.fromJson(
        response.data['data'],
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    StoreFormModel form,
  ) async {
    try {
      final response = await dio.put(
        '/pos/stores-mobile/$enc',
        data: form.toJson(),
      );

      return response.data['data']['encryption']
          as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('/pos/stores-mobile/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> selectStore(
    int idStore,
  ) async {
    try {
      final response = await dio.post(
        '/pos/stores-mobile/select',
        data: {
          'id_store': idStore,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> verifyPin(
    String enc,
    String pin,
  ) async {
    try {
      final response = await dio.post(
        '/pos/stores-mobile/$enc/verify-pin',
        data: {
          'pin': pin,
        },
      );

      return response.data as Map<String, dynamic>;
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