import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';

class LocationReportRemoteDataSource {
  final Dio dio;
  LocationReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getLocationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/location-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => LocationReportModel.fromJson(e)).toList(),
        'meta': LocationReportPaginationMeta.fromJson(paginator),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<LocationReportDetailModel> getLocationReportDetail(
    String encryption,
  ) async {
    try {
      final response = await dio.get('/inventory/location-report/$encryption');
      return LocationReportDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<LocationDetailPage<T>> getLocationDetailTab<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/location-report/$encryption',
        queryParameters: {'type': type, 'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> items = json['data'] ?? [];
      return LocationDetailPage<T>(
        items: items.map((e) => parser(e as Map<String, dynamic>)).toList(),
        meta: LocationDetailPageMeta.fromJson(
          (json['meta'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<WarehouseOptionModel>> getFormOptions() async {
    try {
      final response = await dio.get('/inventory/location-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> warehouses = json['data']?['warehouses'] ?? [];
      return warehouses.map((e) => WarehouseOptionModel.fromJson(e)).toList();
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