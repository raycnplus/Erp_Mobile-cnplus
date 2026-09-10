import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';

class PeriodClosingRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/period-closing'; 

  PeriodClosingRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 15,
    String? status,
    String? type,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: { 
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => PeriodClosingModel.fromJson(e)).toList(),
        'meta': PeriodClosingPaginationMeta(
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

  Future<PeriodClosingDetailModel> getDetail(String encryption) async {
    try {
      final r = await dio.get('$_base/$encryption'); 
      return PeriodClosingDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PeriodClosingModel> store(PeriodClosingFormModel f) async {
    try {
      final r = await dio.post(_base, data: f.toJson()); 
      return PeriodClosingModel.fromJson(r.data['data']);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PeriodClosingModel> update(String encryption, PeriodClosingFormModel f) async {
    try {
      final r = await dio.put('$_base/$encryption', data: f.toJson()); 
      return PeriodClosingModel.fromJson(r.data['data']);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete('$_base/$encryption'); 
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PeriodClosingModel> post(String encryption) async {
    try {
      final r = await dio.post('$_base/$encryption/post');
      return PeriodClosingModel.fromJson(r.data['data']);
    } on DioException catch (e) {
      throw Exception(_postErr(e));
    }
  }

  Future<List<PeriodClosingBalanceRow>> getBalanceDetail({
    required int year,
    String type = 'MONTHLY',
    int? month,
  }) async {
    try {
      final r = await dio.get(
        '$_base/balance-detail', 
        queryParameters: {
          'year': year,
          'type': type,
          if (month != null) 'month': month,
        },
      );
      return (r.data['data'] as List)
          .map((e) => PeriodClosingBalanceRow.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  String _postErr(DioException e) {
    final data = e.response?.data;
    final base = data is Map ? (data['message']?.toString() ?? 'Failed to post') : 'Failed to post';

    if (data is Map && data['errors'] is List) {
      final lines = (data['errors'] as List)
          .map((x) => '${x['module']}: ${x['count']} unposted')
          .join(', ');
      return '$base ($lines)';
    }

    if (data is Map && data['diff'] != null) {
      return '$base (debit: ${data['debit']}, credit: ${data['credit']}, diff: ${data['diff']})';
    }

    return base;
  }

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}