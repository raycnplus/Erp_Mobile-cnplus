import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/models/top_purchasing_product_report_models.dart';

class TopPurchasingProductReportRemoteDataSource {
  final Dio dio;

  TopPurchasingProductReportRemoteDataSource(
    this.dio,
  );

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>>
      getTopPurchasingProductReportList({
    int page = 1,
    int perPage = 15,
    String? search,
    int? idVendor,
    String? dateFrom,
    String? dateTo,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '/purchase/top-purchasing-product-report',
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
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final paginator =
          json['data'] as Map<String, dynamic>;

      final items =
          paginator['data'] as List<dynamic>? ?? [];

      return {
        'items': items
            .map(
              (e) =>
                  TopPurchasingProductReportModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),

        'meta':
            TopPurchasingProductReportPaginationMeta.fromJson(
          paginator,
        ),

        'summary':
            TopPurchasingProductReportSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {},
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

  Future<TopPurchasingProductReportFormOptions>
      getFormOptions() async {
    try {
      final response = await dio.get(
        '/purchase/top-purchasing-product-report/form-options',
      );

      final json =
          response.data as Map<String, dynamic>;

      return TopPurchasingProductReportFormOptions.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      );
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  // ============================================================
  // ERROR HANDLER
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