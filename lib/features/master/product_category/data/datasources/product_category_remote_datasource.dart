import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/models/product_category_models.dart';

class ProductCategoryRemoteDataSource {
  final Dio dio;
  ProductCategoryRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getProductCategoryList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/product-categories',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => ProductCategoryModel.fromJson(e)).toList(),
        'meta': ProductCategoryPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<ProductCategoryDetailModel> getProductCategoryDetail(String encryption) async {
    try {
      final response = await dio.get('/master/product-categories/$encryption');
      return ProductCategoryDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createProductCategory(ProductCategoryFormModel formData) async {
    try {
      await dio.post('/master/product-categories', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateProductCategory(
      String encryption, ProductCategoryFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/product-categories/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteProductCategory(String encryption) async {
    try {
      await dio.delete('/master/product-categories/$encryption');
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