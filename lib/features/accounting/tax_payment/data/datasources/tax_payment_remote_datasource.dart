import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';

class TaxPaymentRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/tax-payments';

  TaxPaymentRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page':     page,
        'per_page': perPage,
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => TaxPaymentModel.fromJson(e)).toList(),
        'meta': TaxPaymentPaginationMeta(
          currentPage: _pi(pd['current_page']),
          lastPage:    _pi(pd['last_page']),
          perPage:     _pi(pd['per_page']),
          total:       _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<TaxPaymentDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return TaxPaymentDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<TaxTransactionOption>> searchTransactions(String term, {int? excludeId}) async {
    try {
      final r = await dio.get('$_base/transactions/search', queryParameters: {
        if (term.isNotEmpty) 'term': term,
        if (excludeId != null) 'exclude_id': excludeId,
      });
      return (r.data['data'] as List? ?? []).map((e) => TaxTransactionOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(TaxPaymentFormModel f) async {
    try {
      final r = await dio.post(_base, data: f.toJson());
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String enc, TaxPaymentFormModel f) async {
    try {
      final r = await dio.put('$_base/$enc', data: f.toJson());
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> post(String enc) async {
    try {
      final r = await dio.put('$_base/$enc', data: {'status': 'post'});
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> unpost(String enc) async {
    try {
      final r = await dio.post('$_base/$enc/unpost');
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String enc) async {
    try {
      await dio.delete('$_base/$enc');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String? _extractEncryption(dynamic data) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map && inner['encryption'] != null) {
        return inner['encryption'].toString();
      }
    }
    return null;
  }

  String _err(DioException e) {
    final d = e.response?.data;
    if (d is Map) {
      final errors = d['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }
      if (d['message'] != null) return d['message'].toString();
    }
    return d?.toString() ?? 'Network error';
  }

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}