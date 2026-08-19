import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';

class TransferInRemoteDataSource {
  final Dio dio;
  static const _base = '/inventory/transfer-in';

  TransferInRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
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
        'items': (pd['data'] as List).map((e) => TransferInModel.fromJson(e)).toList(),
        'meta': TransferInPaginationMeta(
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

  Future<TransferInDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return TransferInDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> process(String encryption, TransferInFormModel f, String action) async {
    try {
      final r = await dio.post('$_base/$encryption/process', data: f.toJson(action));
      return r.data as Map<String, dynamic>;
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