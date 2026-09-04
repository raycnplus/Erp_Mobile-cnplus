import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/models/ppn_report_models.dart';

class PPNReportRemoteDataSource {
  final Dio dio;

  PPNReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPPNReportList({
    int page = 1,
    int perPage = 15,
    String? reference,
    String? taxWithholder,
    String? npwp,
    String? eBupot,
    String? type,
    String? source,
    String? dateFrom,
    String? dateTo,
    String? sortField,
    String? sortDirection,
  }) async {
    try {
      final response = await dio.get(
        '/sales/ppn-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,

          if (reference != null &&
              reference.isNotEmpty)
            'reference': reference,

          if (taxWithholder != null &&
              taxWithholder.isNotEmpty)
            'tax_withholder': taxWithholder,

          if (npwp != null &&
              npwp.isNotEmpty)
            'npwp': npwp,

          if (eBupot != null &&
              eBupot.isNotEmpty)
            'e_bupot': eBupot,

          if (type != null &&
              type.isNotEmpty)
            'type': type,

          if (source != null &&
              source.isNotEmpty)
            'source': source,

          if (dateFrom != null &&
              dateFrom.isNotEmpty)
            'date_from': dateFrom,

          if (dateTo != null &&
              dateTo.isNotEmpty)
            'date_to': dateTo,

          if (sortField != null &&
              sortField.isNotEmpty)
            'sort_field': sortField,

          if (sortDirection != null &&
              sortDirection.isNotEmpty)
            'sort_direction': sortDirection,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final paginator =
          json['data'] as Map<String, dynamic>;

      final List<dynamic> items =
          paginator['data'] ?? [];

      return {
        'items': items
            .map(
              (e) => PPNReportModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),

        'meta':
            PPNReportPaginationMeta.fromJson(
          paginator,
        ),

        'summary':
            PPNReportSummary.fromJson(
          json['summary'] ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

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