import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/models/sold_product_report_models.dart';

class SoldProductReportRemoteDataSource {
  final Dio dio;
  static const _base = '/pos/sold-product-report';

  SoldProductReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? idStore,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        _base,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (dateFrom != null) 'date_from': dateFrom,
          if (dateTo != null) 'date_to': dateTo,
          if (idStore != null && idStore != 'All') 'id_store': idStore,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => SoldProductReportItem.fromJson(e)).toList(),
        'meta': SoldProductReportPaginationMeta(
          currentPage: _pi(pd['current_page']),
          lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']),
          total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<SoldProductReportFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return SoldProductReportFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}