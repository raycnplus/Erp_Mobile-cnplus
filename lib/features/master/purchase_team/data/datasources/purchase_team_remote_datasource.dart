import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/models/purchase_team_models.dart';

class PurchaseTeamRemoteDataSource {
  final Dio dio;
  PurchaseTeamRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPurchaseTeamList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/purchase/purchase-teams',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final List<dynamic> items = paginatedData['data'] ?? [];
      return {
        'items': items.map((e) => PurchaseTeamModel.fromJson(e)).toList(),
        'meta': PurchaseTeamPaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<PurchaseTeamDetailModel> getPurchaseTeamDetail(
      String encryption) async {
    try {
      final response =
          await dio.get('/purchase/purchase-teams/$encryption');
      return PurchaseTeamDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<PurchaseTeamDropdownData> getFormOptions() async {
    try {
      final response =
          await dio.get('/purchase/purchase-teams/form-options');
      return PurchaseTeamDropdownData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createPurchaseTeam(PurchaseTeamFormModel formData) async {
    try {
      await dio.post('/purchase/purchase-teams', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updatePurchaseTeam(
      String encryption, PurchaseTeamFormModel formData) async {
    try {
      final id = formData.idPurchaseTeam;
      if (id == null) throw Exception('id_purchase_team is null — cannot update');
      final response = await dio.put(
        '/purchase/purchase-teams/$id',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deletePurchaseTeam(String encryption) async {
    try {
      await dio.delete('/purchase/purchase-teams/$encryption');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ??
          'Server error: ${e.response?.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}