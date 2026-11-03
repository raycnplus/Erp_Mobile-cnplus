import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/models/transaction_history_models.dart';

class TransactionHistoryRemoteDataSource {
  final Dio dio;
  static const _base = '/pos/transaction-history';

  TransactionHistoryRemoteDataSource(this.dio);

  Map<String, String> _filterParams({
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) =>
      {
        if (dateFrom != null && dateTo != null) ...{'date_from': dateFrom, 'date_to': dateTo},
        if (paymentMethod != null && paymentMethod.isNotEmpty) 'payment_method': paymentMethod,
        if (status != null && status.isNotEmpty) 'status': status,
        if (storeIds != null && storeIds.isNotEmpty) 'store_ids': storeIds,
        if (search != null && search.isNotEmpty) 'search': search,
      };

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page,
        'per_page': perPage,
        ..._filterParams(
          dateFrom: dateFrom,
          dateTo: dateTo,
          paymentMethod: paymentMethod,
          status: status,
          storeIds: storeIds,
          search: search,
        ),
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => TransactionHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': TransactionHistoryPaginationMeta.fromJson(pd),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<TransactionHistoryFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return TransactionHistoryFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<TransactionHistoryDetail> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return TransactionHistoryDetail.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  HistoryExportUrlInfo getExportListUrl({
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) =>
      _buildExportInfo(
        'export',
        _filterParams(
          dateFrom: dateFrom,
          dateTo: dateTo,
          paymentMethod: paymentMethod,
          status: status,
          storeIds: storeIds,
          search: search,
        ),
      );

  HistoryExportUrlInfo getExportDetailUrl(String enc) => _buildExportInfo('$enc/export', const {});

  HistoryExportUrlInfo _buildExportInfo(String path, Map<String, String> query) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: query.isEmpty ? null : query,
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return HistoryExportUrlInfo(url: uri.toString(), headers: headers);
  }

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}