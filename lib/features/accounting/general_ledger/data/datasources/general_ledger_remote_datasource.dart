import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/models/general_ledger_models.dart';

class GeneralLedgerRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/general-ledger';

  GeneralLedgerRemoteDataSource(this.dio);

  Future<GeneralLedgerReportResult> getReport({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (coaFrom != null && coaFrom != 'All') 'coa_from': coaFrom,
        if (coaTo != null && coaTo != 'All') 'coa_to': coaTo,
      });
      return GeneralLedgerReportResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<GeneralLedgerFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return GeneralLedgerFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) =>
      _buildExportInfo('export-pdf', dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);

  ExportUrlInfo getExportExcelUrl({
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) =>
      _buildExportInfo('export-excel', dateFrom: dateFrom, dateTo: dateTo, coaFrom: coaFrom, coaTo: coaTo);

  ExportUrlInfo _buildExportInfo(
    String path, {
    String? dateFrom,
    String? dateTo,
    String? coaFrom,
    String? coaTo,
  }) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: {
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (coaFrom != null && coaFrom != 'All') 'coa_from': coaFrom,
        if (coaTo != null && coaTo != 'All') 'coa_to': coaTo,
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