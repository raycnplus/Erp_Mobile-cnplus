import 'package:dio/dio.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/data/models/pph_report_models.dart';

class PPHReportRemoteDataSource {
  final Dio dio;

  PPHReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPPHReportList({
    int page = 1,
    int perPage = 15,
    String? reference,
    String? paymentNumber,
    String? taxWithholder,
    String? npwp,
    String? eBupot,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? sortField,
    String? sortDirection,
  }) async {
    try {
      final response = await dio.get(
        '/sales/pph-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,

          if (reference != null && reference.isNotEmpty)
            'reference': reference,

          if (paymentNumber != null &&
              paymentNumber.isNotEmpty)
            'payment_number': paymentNumber,

          if (taxWithholder != null &&
              taxWithholder.isNotEmpty)
            'tax_withholder': taxWithholder,

          if (npwp != null && npwp.isNotEmpty)
            'npwp': npwp,

          if (eBupot != null && eBupot.isNotEmpty)
            'e_bupot': eBupot,

          if (type != null && type.isNotEmpty)
            'type': type,

          if (dateFrom != null && dateFrom.isNotEmpty)
            'date_from': dateFrom,

          if (dateTo != null && dateTo.isNotEmpty)
            'date_to': dateTo,

          if (sortField != null && sortField.isNotEmpty)
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
              (e) => PPHReportModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),

        'meta':
            PPHReportPaginationMeta.fromJson(
          paginator,
        ),

        'summary':
            PPHReportSummary.fromJson(
          json['summary'] ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e),
      );
    }
  }

  String _handleDioError(DioException e) {
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