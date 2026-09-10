import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';

class BpeRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/bpe-management'; 

  BpeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 15,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        _base, 
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => BpeModel.fromJson(e)).toList(),
        'meta': BpePaginationMeta(
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

  Future<BpeDetailModel> getDetail(String encryption) async {
    try {
      final r = await dio.get('$_base/$encryption'); 
      return BpeDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BpeModel> store(BpeFormModel f, String status) async {
    try {
      final r = await dio.post(
        _base, 
        data: status == 'validate' ? f.toValidateJson() : f.toJson(status),
      );
      return BpeModel.fromJson(r.data['data']);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<BpeModel> update(String encryption, BpeFormModel f, String status) async {
    try {
      final r = await dio.put(
        '$_base/$encryption', 
        data: status == 'validate' ? f.toValidateJson() : f.toJson(status),
      );
      return BpeModel.fromJson(r.data['data']);
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

  Future<List<BpeAvailableInvoice>> searchInvoices({
    String? keyword, 
    int? exceptBpeId
  }) async {
    try {
      final r = await dio.get(
        '$_base/search-invoices', 
        queryParameters: {
          if (keyword != null && keyword.isNotEmpty) 'q': keyword,
          if (exceptBpeId != null) 'id_bpe': exceptBpeId,
        },
      );
      return (r.data['data'] as List)
          .map((e) => BpeAvailableInvoice.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}

class BpePaginationMeta {
  final int currentPage, lastPage, perPage, total;

  BpePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}