import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';

class AssetDisposalRemoteDataSource {
  final Dio dio;
  static const _base = '/accounting/asset-disposals';

  AssetDisposalRemoteDataSource(this.dio);

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
        'items': (pd['data'] as List).map((e) => AssetDisposalModel.fromJson(e)).toList(),
        'meta': AssetDisposalPaginationMeta(
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

  Future<AssetDisposalDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('$_base/$enc');
      return AssetDisposalDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<AssetDisposalFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('$_base/form-options');
      return AssetDisposalFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(AssetDisposalFormModel f) async {
    try {
      final r = await dio.post(_base, data: f.toJson('save'));
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String enc, AssetDisposalFormModel f) async {
    try {
      final r = await dio.put('$_base/$enc', data: f.toJson('save'));
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> confirm(String enc) => _action(enc, 'confirm');

  Future<String> post(String enc) => _action(enc, 'post');

  Future<String> _action(String enc, String status) async {
    try {
      final r = await dio.put('$_base/$enc', data: {'status': status});
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> cancel(String enc, String reason) async {
    try {
      final r = await dio.post('$_base/$enc/cancel', data: {'cancel_reason': reason});
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