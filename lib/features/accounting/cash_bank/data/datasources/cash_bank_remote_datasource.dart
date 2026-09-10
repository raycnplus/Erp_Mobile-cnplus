import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';

class CashBankRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/cash-bank';

  CashBankRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? status,
    String? noteType,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page, 'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
        if (noteType != null) 'note_type': noteType,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => CashBankModel.fromJson(e)).toList(),
        'meta': CashBankPaginationMeta(
          currentPage: _pi(pd['current_page']), lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']), total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<CashBankDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return CashBankDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<CashBankFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return CashBankFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> store(CashBankFormModel f, String action) async {
    try {
      final r = await dio.post(_base, data: f.toJson(action));
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> update(String encryption, CashBankFormModel f, String action) async {
    try {
      final r = await dio.put('$_base/$encryption', data: f.toJson(action));
      return r.data as Map<String, dynamic>;
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

  Future<Map<String, dynamic>> unpost(String encryption) async {
    try {
      final r = await dio.post('$_base/$encryption/unpost');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BulkPostResult> bulkPost(List<String> encryptions) async {
    try {
      final r = await dio.post('$_base/bulk-post', data: {'encryptions': encryptions});
      return BulkPostResult.fromJson(r.data as Map<String, dynamic>);
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