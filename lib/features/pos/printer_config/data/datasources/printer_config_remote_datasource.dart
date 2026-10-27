import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';

class PrinterConfigRemoteDataSource {
  final Dio dio;

  PrinterConfigRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/pos/printer',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => PrinterConfigModel.fromJson(e)).toList(),
        'meta': PrinterPaginationMeta(
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

  Future<PrinterConfigModel> getDetail(int id) async {
    try {
      final r = await dio.get('/pos/printer/$id');
      return PrinterConfigModel.fromJson(r.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PrinterConfigModel> store(PrinterConfigFormModel f) async {
    try {
      final r = await dio.post('/pos/printer', data: f.toJson());
      return PrinterConfigModel.fromJson(r.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PrinterConfigModel> update(int id, PrinterConfigFormModel f) async {
    try {
      final r = await dio.put('/pos/printer/$id', data: f.toJson());
      return PrinterConfigModel.fromJson(r.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/pos/printer/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PrinterConfigModel> setDefault(int id) async {
    try {
      final r = await dio.post('/pos/printer/$id/default');
      return PrinterConfigModel.fromJson(r.data['data'] as Map<String, dynamic>);
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