import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';

class LocationRemoteDataSource {
  final Dio dio;
  LocationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getLocationList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/locations',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => LocationModel.fromJson(e)).toList(),
        'meta': LocationPaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<LocationDetailModel> getLocationDetail(String encryption) async {
    try {
      final response = await dio.get('/master/locations/$encryption');
      return LocationDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<LocationDropdownData> getFormOptions() async {
    try {
      final response = await dio.get('/master/locations/form-options');
      return LocationDropdownData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createLocation(LocationFormModel formData) async {
    try {
      await dio.post('/master/locations', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateLocation(
      String encryption, LocationFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/locations/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteLocation(String encryption) async {
    try {
      await dio.delete('/master/locations/$encryption');
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