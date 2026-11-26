import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/models/direct_purchase_report_models.dart';

class DirectPurchaseReportRemoteDataSource {
  final Dio dio;
  static const _base = '/purchase/direct-purchase-report';

  DirectPurchaseReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getDirectPurchaseReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await dio.get(
        _base,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          ..._filterParams(
            idVendor: idVendor,
            idWarehouse: idWarehouse,
            idLocation: idLocation,
            dateFrom: dateFrom,
            dateTo: dateTo,
          ),
        },
      );

      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final items = paginator['data'] as List<dynamic>? ?? [];

      return {
        'items': items
            .map((e) => DirectPurchaseReportModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': DirectPurchaseReportPaginationMeta.fromJson(paginator),
        'summary': DirectPurchaseReportSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<DirectPurchaseReportFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('$_base/form-options');
      final json = response.data as Map<String, dynamic>;
      return DirectPurchaseReportFormOptions.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<DirectPurchaseLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) async {
    try {
      final response = await dio.get(
        '$_base/locations-by-warehouse',
        queryParameters: {'id_warehouse': idWarehouse},
      );
      final json = response.data as Map<String, dynamic>;
      final items = json['data'] as List<dynamic>? ?? [];
      return items
          .map((e) => DirectPurchaseLocationOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  DirectPurchaseReportExportUrlInfo getExportPdfUrl({
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) =>
      _buildExportInfo(
        'export-pdf',
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

  DirectPurchaseReportExportUrlInfo getExportExcelUrl({
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) =>
      _buildExportInfo(
        'export-excel',
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

  DirectPurchaseReportExportUrlInfo _buildExportInfo(
    String path, {
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) {
    final params = _filterParams(
      idVendor: idVendor,
      idWarehouse: idWarehouse,
      idLocation: idLocation,
      dateFrom: dateFrom,
      dateTo: dateTo,
    ).map((k, v) => MapEntry(k, v.toString()));

    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: params,
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return DirectPurchaseReportExportUrlInfo(url: uri.toString(), headers: headers);
  }

  Map<String, dynamic> _filterParams({
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
  }) =>
      {
        if (idVendor != null) 'id_vendor': idVendor,
        if (idWarehouse != null) 'id_warehouse': idWarehouse,
        if (idLocation != null) 'id_location': idLocation,
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      };

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? 'Server error: ${e.response?.statusCode}';
      }
      return 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}