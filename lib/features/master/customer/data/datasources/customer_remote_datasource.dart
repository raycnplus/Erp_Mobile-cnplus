import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class CustomerRemoteDataSource {
  final Dio dio;
  CustomerRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getCustomerList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/customers',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => CustomerModel.fromJson(e)).toList(),
        'meta': CustomerPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CustomerDetailModel> getCustomerDetail(String encryption) async {
    try {
      final response = await dio.get('/master/customers/$encryption');
      return CustomerDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CustomerDropdownData> getFormOptions() async {
    try {
      final response = await dio.get('/master/customers/form-options');
      return CustomerDropdownData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createCustomer(CustomerFormModel formData) async {
    try {
      await dio.post('/master/customers', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateCustomer(
      String encryption, CustomerFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/customers/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteCustomer(String encryption) async {
    try {
      await dio.delete('/master/customers/$encryption');
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