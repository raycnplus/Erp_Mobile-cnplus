import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/models/service_quotation_report_models.dart';

class ServiceQuotationReportRemoteDataSource {
  final Dio dio;
  static const _base = '/sales/service/quotation-report';

  ServiceQuotationReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getServiceQuotationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? customerId,
    int? salesId,
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
            customerId: customerId,
            salesId: salesId,
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
        'items': items.map((e) => ServiceQuotationReportModel.fromJson(e)).toList(),
        'meta': ServiceQuotationReportPaginationMeta.fromJson(paginator),
        'summary': ServiceQuotationReportSummary.fromJson(json['summary'] ?? {}),
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
        'customers': ((data['customers'] ?? []) as List)
            .map((e) => ServiceQuotationCustomerOption.fromJson(e))
            .toList(),
        'salespersons': ((data['salespersons'] ?? []) as List)
            .map((e) => ServiceQuotationSalesPersonOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  ServiceQuotationReportExportUrlInfo getExportPdfUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        'export-pdf',
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  ServiceQuotationReportExportUrlInfo getExportExcelUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        'export-excel',
        customerId: customerId,
        salesId: salesId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );

  ServiceQuotationReportExportUrlInfo _buildExportInfo(
    String path, {
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) {
    final params = _filterParams(
      customerId: customerId,
      salesId: salesId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      status: status,
    ).map((k, v) => MapEntry(k, v.toString()));

    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: params,
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return ServiceQuotationReportExportUrlInfo(url: uri.toString(), headers: headers);
  }

  Map<String, dynamic> _filterParams({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      {
        if (customerId != null) 'customer_id': customerId,
        if (salesId != null) 'sales_id': salesId,
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