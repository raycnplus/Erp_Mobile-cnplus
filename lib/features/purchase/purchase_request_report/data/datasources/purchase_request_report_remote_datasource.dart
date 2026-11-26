import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/models/purchase_request_report_models.dart';

class PurchaseRequestReportRemoteDataSource {
  final Dio dio;
  static const _base = '/purchase/purchase-request-report';

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
        _base,
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
      final response = await dio.get('$_base/form-options');
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
        '$_base/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => PurchaseRequestLocationOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({
    String? dateFrom,
    String? dateTo,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
  }) =>
      _buildExportInfo(
        'export-pdf',
        dateFrom: dateFrom,
        dateTo: dateTo,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
      );

  ExportUrlInfo getExportExcelUrl({
    String? dateFrom,
    String? dateTo,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
  }) =>
      _buildExportInfo(
        'export-excel',
        dateFrom: dateFrom,
        dateTo: dateTo,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
      );

  ExportUrlInfo _buildExportInfo(
    String path, {
    String? dateFrom,
    String? dateTo,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        if (idWarehouse != null) 'id_warehouse': '$idWarehouse',
        if (idLocation != null) 'id_location': '$idLocation',
        if (requestedBy != null) 'requested_by': '$requestedBy',
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return ExportUrlInfo(url: uri.toString(), headers: headers);
  }

  String _handleDioError(DioException e) {
    final data = e.response?.data;
    if (e.response != null) {
      if (data is Map && data['message'] != null) return data['message'].toString();
      return 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}