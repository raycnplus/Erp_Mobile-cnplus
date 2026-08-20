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
      // Laravel paginate(): meta + items are both inside json['data']
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
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '/inventory/warehouse-report/$idWarehouse',
      );
      return WarehouseReportDetailModel.fromJson(response.data);
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
