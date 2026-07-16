import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';

class WarehouseRemoteDataSource {
  final Dio dio;
  WarehouseRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getWarehouseList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/master/warehouses',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return {
        'items': data.map((e) => WarehouseModel.fromJson(e)).toList(),
        'meta': WarehousePaginationMeta.fromJson(json),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<WarehouseDetailModel> getWarehouseDetail(String encryption) async {
    try {
      final response = await dio.get('/master/warehouses/$encryption');
      return WarehouseDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createWarehouse(WarehouseFormModel formData) async {
    try {
      await dio.post('/master/warehouses', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateWarehouse(
      String encryption, WarehouseFormModel formData) async {
    try {
      final response = await dio.put(
        '/master/warehouses/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteWarehouse(String encryption) async {
    try {
      await dio.delete('/master/warehouses/$encryption');
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