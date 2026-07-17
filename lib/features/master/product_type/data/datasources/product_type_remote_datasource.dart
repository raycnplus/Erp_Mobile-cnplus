import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';

class ProductTypeRemoteDataSource {
  final Dio dio;
  ProductTypeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getProductTypeList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/product-types',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => ProductTypeModel.fromJson(e)).toList(),
        'meta': ProductTypePaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<ProductTypeDetailModel> getProductTypeDetail(String encryption) async {
    try {
      final response = await dio.get('/master/product-types/$encryption');
      return ProductTypeDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createProductType(ProductTypeFormModel formData) async {
    try {
      await dio.post('/master/product-types', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateProductType(
      String encryption, ProductTypeFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/product-types/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteProductType(String encryption) async {
    try {
      await dio.delete('/master/product-types/$encryption');
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