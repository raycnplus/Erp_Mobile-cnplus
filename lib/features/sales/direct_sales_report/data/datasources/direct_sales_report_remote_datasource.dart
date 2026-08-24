import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/models/direct_sales_report_models.dart';

class DirectSalesReportRemoteDataSource {
  final Dio dio;
  DirectSalesReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getDirectSalesReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        '/sales/direct-sales-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];

      return {
        'items': items
            .map((e) => DirectSalesReportModel.fromJson(e))
            .toList(),
        'meta': DirectSalesReportPaginationMeta.fromJson(paginator),
        'summary': DirectSalesReportSummary.fromJson(
          json['summary'] ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get(
        '/sales/direct-sales-report/form-options',
      );

      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};

      return {
        'warehouses': ((data['warehouses'] ?? []) as List)
            .map((e) => DirectSalesWarehouseOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<DirectSalesLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '/sales/direct-sales-report/locations-by-warehouse',
        queryParameters: {
          'id_warehouse': idWarehouse,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];

      return data
          .map((e) => DirectSalesLocationOption.fromJson(e))
          .toList();
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