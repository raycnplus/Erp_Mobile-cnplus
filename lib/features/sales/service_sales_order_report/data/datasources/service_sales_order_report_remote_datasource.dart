import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/models/service_sales_order_report_models.dart';

class ServiceSalesOrderReportRemoteDataSource {
  final Dio dio;
  static const _base = '/sales/service/sales-order-report';

  ServiceSalesOrderReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getServiceSalesOrderReportList({
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
        'items': items.map((e) => ServiceSalesOrderReportModel.fromJson(e)).toList(),
        'meta': ServiceSalesOrderReportPaginationMeta.fromJson(paginator),
        'summary': ServiceSalesOrderReportSummary.fromJson(json['summary'] ?? {}),
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
            .map((e) => ServiceSalesOrderCustomerOption.fromJson(e))
            .toList(),
        'salespersons': ((data['salespersons'] ?? []) as List)
            .map((e) => ServiceSalesOrderSalesPersonOption.fromJson(e))
            .toList(),
        'statuses': ((data['statuses'] ?? []) as List)
            .map((e) => '$e')
            .toList(),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  ServiceSalesOrderReportExportUrlInfo getExportPdfUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        '$_base/export-pdf',
        _filterParams(
          customerId: customerId,
          salesId: salesId,
          dateFrom: dateFrom,
          dateTo: dateTo,
          status: status,
        ),
      );

  ServiceSalesOrderReportExportUrlInfo getExportExcelUrl({
    int? customerId,
    int? salesId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _buildExportInfo(
        '$_base/export-excel',
        _filterParams(
          customerId: customerId,
          salesId: salesId,
          dateFrom: dateFrom,
          dateTo: dateTo,
          status: status,
        ),
      );

  ServiceSalesOrderReportExportUrlInfo getExportDetailPdfUrl(String encryption) =>
      _buildExportInfo('$_base/detail/$encryption/export-pdf', const {});

  ServiceSalesOrderReportExportUrlInfo getExportDetailExcelUrl(String encryption) =>
      _buildExportInfo('$_base/detail/$encryption/export-excel', const {});

  ServiceSalesOrderReportExportUrlInfo _buildExportInfo(
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

    return ServiceSalesOrderReportExportUrlInfo(url: uri.toString(), headers: headers);
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