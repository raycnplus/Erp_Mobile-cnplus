import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/models/top_customer_report_models.dart';

class TopCustomerReportRemoteDataSource {
  final Dio dio;
  TopCustomerReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getTopCustomerReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await dio.get(
        '/sales/top-customer-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => TopCustomerReportModel.fromJson(e)).toList(),
        'meta': TopCustomerReportPaginationMeta.fromJson(paginator),
        'summary': TopCustomerReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<TopCustomerWarehouseOption>> getFormOptions() async {
    try {
      final response = await dio.get('/sales/top-customer-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> warehouses = json['data']?['warehouses'] ?? [];
      return warehouses.map((e) => TopCustomerWarehouseOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<TopCustomerLocationOption>> getLocationsByWarehouse(int idWarehouse) async {
    try {
      final response = await dio.get(
        '/sales/top-customer-report/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => TopCustomerLocationOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}