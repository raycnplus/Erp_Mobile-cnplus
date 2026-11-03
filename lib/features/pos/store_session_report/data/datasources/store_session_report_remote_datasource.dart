import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';

class StoreSessionReportRemoteDataSource {
  final Dio dio;
  static const _base = '/pos/store-report';

  StoreSessionReportRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? idStore,
    String? status,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page,
        'per_page': perPage,
        if (idStore != null) 'id_store': idStore,
        if (status != null && status.isNotEmpty) 'status': status,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => StoreSessionItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': StoreSessionPaginationMeta.fromJson(pd),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreSessionFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return StoreSessionFormOptions.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreSessionDetail> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return StoreSessionDetail.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getTransactions(
    String enc, {
    int page = 1,
    int perPage = 15,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? search,
  }) async {
    try {
      final r = await dio.get('$_base/$enc/transactions', queryParameters: {
        'page': page,
        'per_page': perPage,
        if (dateFrom != null && dateTo != null) ...{'date_from': dateFrom, 'date_to': dateTo},
        if (paymentMethod != null && paymentMethod.isNotEmpty) 'payment_method': paymentMethod,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      final summary = (r.data['summary'] as Map<String, dynamic>?) ?? {};
      return {
        'items': (pd['data'] as List)
            .map((e) => StoreSessionTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': StoreSessionPaginationMeta.fromJson(pd),
        'totalAmountAll': double.tryParse(summary['total_amount_all']?.toString() ?? '') ?? 0.0,
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getCashMovements(
    String enc, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final r = await dio.get('$_base/$enc/cash-movements', queryParameters: {
        'page': page,
        'per_page': perPage,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => StoreSessionCashMovement.fromJson(e as Map<String, dynamic>))
            .toList(),
        'meta': StoreSessionPaginationMeta.fromJson(pd),
        'summary': StoreSessionCashSummary.fromJson(
          (r.data['summary'] as Map<String, dynamic>?) ?? {},
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<StoreSessionTransactionDetail> getTransactionDetail(String enc) async {
    try {
      final r = await dio.get('$_base/transaction/$enc');
      return StoreSessionTransactionDetail.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  SessionExportUrlInfo getExportSessionUrl(
    String enc, {
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
  }) =>
      _buildExportInfo('$enc/export', {
        if (dateFrom != null && dateTo != null) ...{'date_from': dateFrom, 'date_to': dateTo},
        if (paymentMethod != null && paymentMethod.isNotEmpty) 'payment_method': paymentMethod,
      });

  SessionExportUrlInfo getExportTransactionUrl(String enc) =>
      _buildExportInfo('transaction/$enc/export', const {});

  SessionExportUrlInfo _buildExportInfo(String path, Map<String, String> query) {
    final uri = Uri.parse('${dio.options.baseUrl}$_base/$path').replace(
      queryParameters: query.isEmpty ? null : query,
    );

    final headers = <String, String>{};
    dio.options.headers.forEach((k, v) {
      if (v != null) headers[k] = v.toString();
    });

    return SessionExportUrlInfo(url: uri.toString(), headers: headers);
  }

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';
}