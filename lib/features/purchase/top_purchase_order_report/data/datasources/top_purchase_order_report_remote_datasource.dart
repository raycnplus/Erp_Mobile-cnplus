import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/models/top_purchase_order_report_models.dart';

class TopPurchaseOrderReportRemoteDataSource {
  final Dio dio;

  TopPurchaseOrderReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getTopPurchaseOrderReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    String? dateFrom,
    String? dateTo,
    int? limit,
    bool all = false,
  }) async {
    try {
      final response = await dio.get(
        '/purchase/top-purchase-order-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,

          if (search != null &&
              search.trim().isNotEmpty)
            'search': search.trim(),

          if (idVendor != null)
            'id_vendor': idVendor,

          if (dateFrom != null &&
              dateFrom.isNotEmpty)
            'date_from': dateFrom,

          if (dateTo != null &&
              dateTo.isNotEmpty)
            'date_to': dateTo,

          if (limit != null)
            'limit': limit,

          if (all)
            'all': true,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final rawData = json['data'];

      // Endpoint punya 2 response mode:
      // 1. all=true -> List
      // 2. normal -> Laravel paginator
      if (rawData is List) {
        final items = rawData
            .map(
              (e) =>
                  TopPurchaseOrderReportModel
                      .fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();

        return {
          'items': items,
          'meta':
              TopPurchaseOrderReportPaginationMeta(
            currentPage: 1,
            lastPage: 1,
            perPage: items.length,
            total: items.length,
          ),
          'summary':
              TopPurchaseOrderReportSummary(
            totalAmountRaw: '0.00',
            totalRecords: items.length,
          ),
        };
      }

      final paginator =
          rawData as Map<String, dynamic>;

      final items =
          paginator['data']
                  as List<dynamic>? ??
              [];

      return {
        'items': items
            .map(
              (e) =>
                  TopPurchaseOrderReportModel
                      .fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),

        'meta':
            TopPurchaseOrderReportPaginationMeta
                .fromJson(
          paginator,
        ),

        'summary':
            TopPurchaseOrderReportSummary
                .fromJson(
          json['summary']
                  as Map<String, dynamic>? ??
              {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<TopPurchaseOrderReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/purchase/top-purchase-order-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return TopPurchaseOrderReportFormOptions
          .fromJson(
        json['data']
                as Map<String, dynamic>? ??
            {},
      );
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _handleDioError(
    DioException e,
  ) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return data['message'] ??
            'Server error: ${e.response?.statusCode}';
      }

      return 'Server error: ${e.response?.statusCode}';
    }

    return 'Network error: ${e.message}';
  }
}