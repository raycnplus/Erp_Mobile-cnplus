import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';

class CoaRemoteDataSource {
  final Dio dio;
  CoaRemoteDataSource(this.dio);

  Future<List<CoaModel>> getCoaList({String? search}) async {
    try {
      final params = <String, dynamic>{};
      if (search != null && search.isNotEmpty) params['search'] = search;
      final response = await dio.get('/accounting/coa', queryParameters: params);
      final json = response.data as Map<String, dynamic>;
      final List<dynamic> data = json['data'] ?? [];
      return data.map((e) => CoaModel.fromJson(e)).toList();
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<CoaDetailModel> getCoaDetail(String encryption) async {
    try {
      final response = await dio.get('/accounting/coa/$encryption');
      return CoaDetailModel.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<CoaFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('/accounting/coa/form-options');
      return CoaFormOptions.fromJson(response.data);
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<int> getAutonumber({int? parentId, String? isHeader}) async {
    try {
      final params = <String, dynamic>{};
      if (parentId != null) params['parent_id'] = parentId;
      if (isHeader != null) params['is_header'] = isHeader;
      final response = await dio.get('/accounting/coa/autonumber', queryParameters: params);
      return response.data['next_number'] ?? 0;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<bool> checkChildren(String encryption) async {
    try {
      final response = await dio.get('/accounting/coa/$encryption/children');
      return response.data['has_children'] == true;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> createCoa(CoaFormModel formData) async {
    try { await dio.post('/accounting/coa', data: formData.toJson()); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<String> updateCoa(String encryption, CoaFormModel formData) async {
    try {
      final response = await dio.put('/accounting/coa/$encryption', data: formData.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) { throw Exception(_err(e)); }
  }

  Future<void> deleteCoa(String encryption) async {
    try { await dio.delete('/accounting/coa/$encryption'); }
    on DioException catch (e) { throw Exception(_err(e)); }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}