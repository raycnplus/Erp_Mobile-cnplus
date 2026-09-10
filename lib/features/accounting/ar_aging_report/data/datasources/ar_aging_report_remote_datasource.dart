import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/models/ar_aging_report_models.dart';

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}

class ARAgingReportRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/ar-aging-report';

  ARAgingReportRemoteDataSource(this.dio);

  Future<ARAgingResult> getReport({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        if (customerId != null) 'customer_id': customerId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (viewType != null) 'view_type': viewType,
      });
      return ARAgingResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ARAgingFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return ARAgingFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => _buildExportInfo('export-pdf', customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);

  ExportUrlInfo getExportExcelUrl({
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) => _buildExportInfo('export-excel', customerId: customerId, dateFrom: dateFrom, dateTo: dateTo, viewType: viewType);

  ExportUrlInfo _buildExportInfo(
    String path, {
    int? customerId,
    String? dateFrom,
    String? dateTo,
    String? viewType,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        if (customerId != null) 'customer_id': customerId.toString(),
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (viewType != null) 'view_type': viewType,
      },
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return ExportUrlInfo(url: uri.toString(), headers: headers);
  }

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}