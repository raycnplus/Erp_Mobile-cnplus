import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/models/sales_order_report_models.dart';

class SalesOrderReportRemoteDataSource {
  final Dio dio;
  static const _base = '/sales/sales-order-report';

  SalesOrderReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getSalesOrderReportList({
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
        _base,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
          ..._filterParams(
            idWarehouse: idWarehouse,
            idLocation: idLocation,
            dateFrom: dateFrom,
            dateTo: dateTo,
            status: status,
          ),
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => SalesOrderReportModel.fromJson(e)).toList(),
        'meta': SalesOrderReportPaginationMeta.fromJson(paginator),
        'summary': SalesOrderReportSummary.fromJson(json['summary'] ?? {}),
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
            .map((e) => SalesOrderWarehouseOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<SalesOrderLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '$_base/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => SalesOrderLocationOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  SalesOrderReportExportUrlInfo getExportPdfUrl({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        '$_base/export-pdf',
        _filterParams(
          idWarehouse: idWarehouse,
          idLocation: idLocation,
          dateFrom: dateFrom,
          dateTo: dateTo,
          status: status,
        ),
      );

  SalesOrderReportExportUrlInfo getExportExcelUrl({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        '$_base/export-excel',
        _filterParams(
          idWarehouse: idWarehouse,
          idLocation: idLocation,
          dateFrom: dateFrom,
          dateTo: dateTo,
          status: status,
        ),
      );

  SalesOrderReportExportUrlInfo getExportDetailPdfUrl(String encryption) =>
      _buildExportInfo('$_base/detail/$encryption/export-pdf', const {});

  SalesOrderReportExportUrlInfo getExportDetailExcelUrl(String encryption) =>
      _buildExportInfo('$_base/detail/$encryption/export-excel', const {});

  SalesOrderReportExportUrlInfo _buildExportInfo(
    String path,
    Map<String, dynamic> params,
  ) {
    final uri = Uri.parse('${dio.options.baseUrl}$path').replace(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return SalesOrderReportExportUrlInfo(url: uri.toString(), headers: headers);
  }

  Map<String, dynamic> _filterParams({
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      {
        if (idWarehouse != null) 'id_warehouse': idWarehouse,
        if (idLocation != null) 'id_location': idLocation,
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        if (status != null && status.isNotEmpty) 'status': status,
      };

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}