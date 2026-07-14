import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';

class BankAccountRemoteDataSource {
  final Dio dio;

  BankAccountRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/accounting/bank-accounts',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final items = paginatedData['data'] as List<dynamic>? ?? [];
      return {
        'items': items.map((e) => BankAccountModel.fromJson(e)).toList(),
        'meta': BankAccountPaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BankAccountDetailModel> getDetail(String encryption) async {
    try {
      final response =
          await dio.get('/accounting/bank-accounts/$encryption');
      return BankAccountDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BankAccountFormOptions> getFormOptions() async {
    try {
      final response =
          await dio.get('/accounting/bank-accounts/form-options');
      return BankAccountFormOptions.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(BankAccountFormModel form) async {
    try {
      await dio.post('/accounting/bank-accounts', data: form.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String encryption, BankAccountFormModel form) async {
    try {
      final response = await dio.put(
        '/accounting/bank-accounts/$encryption',
        data: form.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete('/accounting/bank-accounts/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data['message'] ?? 'Network error: ${e.message}';
}