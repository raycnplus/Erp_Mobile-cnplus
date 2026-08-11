import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';

class ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getProductList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/products',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => ProductModel.fromJson(e)).toList(),
        'meta': ProductPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<ProductDetailModel> getProductDetail(String encryption) async {
    try {
      final response = await dio.get('/master/products/$encryption');
      return ProductDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<ProductDropdownData> getFormOptions() async {
    try {
      final response = await dio.get('/master/products/form-options');
      return ProductDropdownData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createProduct(ProductFormModel formData) async {
    try {
      await dio.post(
        '/master/products',
        data: formData.toMultipartData(),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateProduct(
      String encryption, ProductFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/products/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['product']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteProduct(String encryption) async {
    try {
      await dio.delete('/master/products/$encryption');
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