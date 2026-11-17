import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/models/warehouse_report_models.dart';

class WarehouseReportRemoteDataSource {
  final Dio dio;
  WarehouseReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getWarehouseReportList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/warehouse-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => WarehouseReportModel.fromJson(e)).toList(),
        'meta': WarehouseReportPaginationMeta.fromJson(paginator),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<WarehouseReportDetailModel> getWarehouseReportDetail(
    String encryption,
  ) async {
    try {
      final response = await dio.get('/inventory/warehouse-report/$encryption');
      return WarehouseReportDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<WarehouseDetailPage<T>> getWarehouseDetailTab<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/warehouse-report/$encryption',
        queryParameters: {'type': type, 'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> items = json['data'] ?? [];
      return WarehouseDetailPage<T>(
        items: items.map((e) => parser(e as Map<String, dynamic>)).toList(),
        meta: WarehouseDetailPageMeta.fromJson(
          (json['meta'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        ),
      );
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