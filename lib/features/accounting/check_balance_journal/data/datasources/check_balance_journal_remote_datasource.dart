import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/models/check_balance_journal_models.dart';

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}

class CheckBalanceJournalRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/check-balance-journal';

  CheckBalanceJournalRemoteDataSource(this.dio);

  Future<CheckBalanceJournalResult> getReport({
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
      });
      return CheckBalanceJournalResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({String? dateFrom, String? dateTo}) =>
      _buildExportInfo('export-pdf', dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo getExportExcelUrl({String? dateFrom, String? dateTo}) =>
      _buildExportInfo('export-excel', dateFrom: dateFrom, dateTo: dateTo);

  ExportUrlInfo _buildExportInfo(
    String path, {
    String? dateFrom,
    String? dateTo,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
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