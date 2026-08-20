import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/models/stock_report_models.dart';

class StockReportRemoteDataSource {
  final Dio dio;
  StockReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getStockReportList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/stock-report',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final paginator = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginator['data'] ?? [];
      return {
        'items': items.map((e) => StockReportModel.fromJson(e)).toList(),
        'meta': StockReportPaginationMeta.fromJson(paginator),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<StockReportDetailModel> getStockReportDetail(int idProduct) async {
    try {
      final response = await dio.get('/inventory/stock-report/$idProduct');
      return StockReportDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}
