import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/models/salespersons_report_models.dart';

class SalespersonsReportRemoteDataSource {
  final Dio dio;

  SalespersonsReportRemoteDataSource(this.dio);

  /// Backend TIDAK punya pagination — endpoint ini selalu mengembalikan
  /// seluruh baris salesperson dalam satu response ('data' berupa array
  /// flat, bukan paginator Laravel seperti report lain).
  Future<List<SalespersonsReportModel>> getSalespersonsReportList({
    String? dateFrom,
    String? dateTo,
    List<int>? idSalesperson,
  }) async {
    try {
      final response = await dio.get(
        '/sales/salespersons-report',
        queryParameters: {
          if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
          if (idSalesperson != null && idSalesperson.isNotEmpty)
            'id_salesperson': idSalesperson,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> items = json['data'] ?? [];
      return items.map((e) => SalespersonsReportModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}