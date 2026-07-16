import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';

class CustomerCategoryRemoteDataSource {
  final Dio dio;
  CustomerCategoryRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getCustomerCategoryList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/customer-categories',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => CustomerCategoryModel.fromJson(e)).toList(),
        'meta': CustomerCategoryPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CustomerCategoryDetailModel> getCustomerCategoryDetail(
      String encryption) async {
    try {
      final response =
          await dio.get('/master/customer-categories/$encryption');
      return CustomerCategoryDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createCustomerCategory(
      CustomerCategoryFormModel formData) async {
    try {
      await dio.post('/master/customer-categories', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateCustomerCategory(
      String encryption, CustomerCategoryFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/customer-categories/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteCustomerCategory(String encryption) async {
    try {
      await dio.delete('/master/customer-categories/$encryption');
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