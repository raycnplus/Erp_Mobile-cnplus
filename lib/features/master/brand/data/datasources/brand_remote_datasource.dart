import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart';

class BrandRemoteDataSource {
  final Dio dio;
  BrandRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getBrandList({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/master/brands',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => BrandModel.fromJson(e)).toList(),
        'meta': BrandPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<BrandDetailModel> getBrandDetail(String encryption) async {
    try {
      final response = await dio.get('/master/brands/$encryption');
      return BrandDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createBrand(BrandFormModel formData) async {
    try {
      await dio.post('/master/brands', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateBrand(String encryption, BrandFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/brands/$encryption',
        data: formData.toJson(),
      );
      final newEncryption = response.data['data']['encryption'] as String;
      return newEncryption;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteBrand(String encryption) async {
    try {
      await dio.delete('/master/brands/$encryption');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}