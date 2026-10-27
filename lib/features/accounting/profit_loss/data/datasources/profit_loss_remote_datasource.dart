import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/models/profit_loss_models.dart';

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}

class ProfitLossRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/profit-loss';

  ProfitLossRemoteDataSource(this.dio);

  Future<ProfitLossResult> getReport({required List<String> dates}) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'dates[]': dates,
      });
      return ProfitLossResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportPdfUrl({required List<String> dates, String? filterType}) =>
      _buildExportInfo('export-pdf', dates: dates, filterType: filterType);

  ExportUrlInfo getExportExcelUrl({required List<String> dates, String? filterType}) =>
      _buildExportInfo('export-excel', dates: dates, filterType: filterType);

  ExportUrlInfo _buildExportInfo(
    String path, {
    required List<String> dates,
    String? filterType,
  }) {
    final params = <String>[
      for (final d in dates) 'dates%5B%5D=${Uri.encodeQueryComponent(d)}',
      if (filterType != null) 'filter_type=${Uri.encodeQueryComponent(filterType)}',
    ];
    final url = '${dio.options.baseUrl}$_base/$path?${params.join('&')}';

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return ExportUrlInfo(url: url, headers: headers);
  }

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}