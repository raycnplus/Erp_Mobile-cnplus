import 'dart:io';
import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';

class BillPaymentRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/bill-payments';

  BillPaymentRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? status,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page, 'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => BillPaymentModel.fromJson(e)).toList(),
        'meta': BillPaymentPaginationMeta(
          currentPage: _pi(pd['current_page']), lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']), total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BillPaymentDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return BillPaymentDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BillPaymentFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return BillPaymentFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<BillOption>> getBills(int idVendor) async {
    try {
      final r = await dio.get('$_base/bills', queryParameters: {'id_vendor': idVendor});
      final data = r.data['data'] as Map<String, dynamic>? ?? {};
      final list = (data['bills'] as List? ?? []);
      return list.map((e) => BillOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<FormData> _buildFormData(BillPaymentFormModel f) async {
    final map = <String, dynamic>{...f.toFieldsMap()};
    if (f.attachmentPath != null && f.attachmentPath!.isNotEmpty) {
      map['attachment'] = await MultipartFile.fromFile(
        f.attachmentPath!,
        filename: f.attachmentPath!.split(Platform.pathSeparator).last,
      );
    }
    return FormData.fromMap(map);
  }

  Future<Map<String, dynamic>> store(BillPaymentFormModel f) async {
    try {
      final data = await _buildFormData(f);
      final r = await dio.post(_base, data: data);
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> update(String encryption, BillPaymentFormModel f) async {
    try {
      final data = await _buildFormData(f);
      data.fields.add(const MapEntry('_method', 'PUT'));
      final r = await dio.post('$_base/$encryption', data: data);
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> confirm(String encryption) async {
    try {
      final r = await dio.post('$_base/$encryption/confirm');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> post(String encryption, {String? journalTransactionDate}) async {
    try {
      final r = await dio.post('$_base/$encryption/post', data: {
        if (journalTransactionDate != null) 'journal_transaction_date': journalTransactionDate,
      });
      return r.data as Map<String, dynamic>;
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

  Future<Map<String, dynamic>> cancel(String encryption, String reason) async {
    try {
      final r = await dio.post('$_base/$encryption/cancel', data: {'cancel_reason': reason});
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

  String _err(DioException e) => e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}