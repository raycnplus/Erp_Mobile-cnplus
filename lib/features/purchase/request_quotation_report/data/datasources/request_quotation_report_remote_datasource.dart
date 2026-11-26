import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';

class RequestQuotationReportRemoteDataSource {
  final Dio dio;
  static const _base = '/purchase/rfq-report';

  RequestQuotationReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getRequestQuotationReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
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
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          if (idVendor != null) 'id_vendor': idVendor,
          if (idWarehouse != null) 'id_warehouse': idWarehouse,
          if (idLocation != null) 'id_location': idLocation,
          if (status != null && status.isNotEmpty) 'status': status,
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final items = paginator['data'] as List<dynamic>? ?? [];

      return {
        'items': items
            .map((e) => RequestQuotationReportModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': RequestQuotationReportPaginationMeta.fromJson(paginator),
        'summary': RequestQuotationReportSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<RequestQuotationReportFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('$_base/form-options');
      final json = response.data as Map<String, dynamic>;

      return RequestQuotationReportFormOptions.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<RequestQuotationLocationOption>> getLocationsByWarehouse(
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
          .map((e) => RequestQuotationLocationOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      _buildExportInfo(
        'export-pdf',
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );

  ExportUrlInfo getExportExcelUrl({
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) =>
      _buildExportInfo(
        'export-excel',
        dateFrom: dateFrom,
        dateTo: dateTo,
        idVendor: idVendor,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        status: status,
      );

  ExportUrlInfo _buildExportInfo(
    String path, {
    String? dateFrom,
    String? dateTo,
    int? idVendor,
    int? idWarehouse,
    int? idLocation,
    String? status,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
        if (idVendor != null) 'id_vendor': '$idVendor',
        if (idWarehouse != null) 'id_warehouse': '$idWarehouse',
        if (idLocation != null) 'id_location': '$idLocation',
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
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      return 'Server error: ${e.response?.statusCode}';
    }

    return 'Network error: ${e.message}';
  }
}