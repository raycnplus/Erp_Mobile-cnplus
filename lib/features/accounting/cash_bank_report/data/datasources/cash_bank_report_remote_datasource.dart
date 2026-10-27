import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/models/cash_bank_report_models.dart';

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}

class CashBankReportRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/cash-bank-report';

  CashBankReportRemoteDataSource(this.dio);

  Future<CashBankReportResult> getReport({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'date_from': dateFrom,
        'date_to': dateTo,
        if (accountId != null && accountId != 'All') 'account_id': accountId,
        if (type != null && type != 'All') 'type': type,
      });
      return CashBankReportResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<CashBankReportFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return CashBankReportFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => _buildExportInfo('export-pdf', dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);

  ExportUrlInfo getExportExcelUrl({
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) => _buildExportInfo('export-excel', dateFrom: dateFrom, dateTo: dateTo, accountId: accountId, type: type);

  ExportUrlInfo _buildExportInfo(
    String path, {
    required String dateFrom,
    required String dateTo,
    String? accountId,
    String? type,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        'date_from': dateFrom,
        'date_to': dateTo,
        if (accountId != null && accountId != 'All') 'account_id': accountId,
        if (type != null && type != 'All') 'type': type,
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