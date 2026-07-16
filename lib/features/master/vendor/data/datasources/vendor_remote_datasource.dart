import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';

class VendorRemoteDataSource {
  final Dio dio;
  VendorRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getVendorList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get(
        '/master/vendors',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => VendorModel.fromJson(e)).toList(),
        'meta': VendorPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<VendorDetailModel> getVendorDetail(String encryption) async {
    try {
      final response = await dio.get('/master/vendors/$encryption');
      return VendorDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/master/vendors/form-options');
      final json = response.data as Map<String, dynamic>;
      return {
        'countries': (json['countries'] as List? ?? [])
            .map((e) => CountryModel.fromJson(e))
            .toList(),
        'currencies': (json['currencies'] as List? ?? [])
            .map((e) => CurrencyModel.fromJson(e))
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createVendor(VendorFormModel formData) async {
    try {
      await dio.post('/master/vendors', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateVendor(String encryption, VendorFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/vendors/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteVendor(String encryption) async {
    try {
      await dio.delete('/master/vendors/$encryption');
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