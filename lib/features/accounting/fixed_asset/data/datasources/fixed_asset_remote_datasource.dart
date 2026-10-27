import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';

class FixedAssetRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/fixed-assets';

  FixedAssetRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? search,
    String? assetStatus,
  }) async {
    try {
      final r = await dio.get(_base, queryParameters: {
        'page': page, 'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (assetStatus != null) 'asset_status': assetStatus,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => FixedAssetModel.fromJson(e)).toList(),
        'meta': FixedAssetPaginationMeta(
          currentPage: _pi(pd['current_page']), lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']), total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<FixedAssetDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return FixedAssetDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<FixedAssetFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return FixedAssetFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> store(FixedAssetFormModel f) async {
    try {
      final r = await dio.post(_base, data: f.toJson());
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> update(String encryption, FixedAssetFormModel f) async {
    try {
      final r = await dio.put('$_base/$encryption', data: f.toJson());
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