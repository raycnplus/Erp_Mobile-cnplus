import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/models/billing_tax_report_models.dart';

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}

class BillingTaxReportRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/billing-tax-report';

  BillingTaxReportRemoteDataSource(this.dio);

  Future<BillingTaxResult> getReport({
    int? year,
    int? month,
    int? customerId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        if (year != null) 'year': year,
        if (month != null) 'month': month,
        if (customerId != null) 'customer_id': customerId,
        'page': page,
        'per_page': perPage,
      });
      return BillingTaxResult.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BillingTaxFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return BillingTaxFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  ExportUrlInfo getExportExcelUrl({int? year, int? month, int? customerId}) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/export-excel').replace(
      queryParameters: {
        if (year != null) 'year': year.toString(),
        if (month != null) 'month': month.toString(),
        if (customerId != null) 'customer_id': customerId.toString(),
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