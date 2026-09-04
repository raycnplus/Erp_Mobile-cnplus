import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/models/purchase_request_report_models.dart';

class PurchaseRequestReportRemoteDataSource {
  final Dio dio;
  PurchaseRequestReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPurchaseRequestReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await dio.get(
        '/purchase/purchase-request-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (requestedBy != null) 'requested_by': requestedBy,
          if (status != null && status.isNotEmpty) 'status': status,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => PurchaseRequestReportModel.fromJson(e)).toList(),
        'meta': PurchaseRequestReportPaginationMeta.fromJson(paginator),
        'summary': PurchaseRequestReportSummary.fromJson(json['summary'] ?? {}),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getFormOptions() async {
    try {
      final response = await dio.get('/purchase/purchase-request-report/form-options');
      final json = response.data as Map<String, dynamic>;
      final data = json['data'] ?? {};
      return {
        'warehouses': ((data['warehouses'] ?? []) as List)
            .map((e) => PurchaseRequestWarehouseOption.fromJson(e))
            .toList(),
        'requesters': ((data['requesters'] ?? []) as List)
            .map((e) => PurchaseRequestRequesterOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List).map((e) => '$e').toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<PurchaseRequestLocationOption>> getLocationsByWarehouse(int idWarehouse) async {
    try {
      final response = await dio.get(
        '/purchase/purchase-request-report/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => PurchaseRequestLocationOption.fromJson(e)).toList();
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