import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';

class SalesTeamRemoteDataSource {
  final Dio dio;
  SalesTeamRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getSalesTeamList({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '/sales/sales-teams',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final dataField = json['data'];

      List<dynamic> items;
      int currentPage, lastPage, perPageVal, total;

      if (dataField is Map) {
        items = dataField['data'] as List? ?? [];
        currentPage = dataField['current_page'] ?? 1;
        lastPage = dataField['last_page'] ?? 1;
        perPageVal = dataField['per_page'] ?? 15;
        total = dataField['total'] ?? 0;
      } else if (dataField is List) {
        items = dataField;
        currentPage = json['current_page'] ?? 1;
        lastPage = json['last_page'] ?? 1;
        perPageVal = json['per_page'] ?? 15;
        total = json['total'] ?? items.length;
      } else {
        items = [];
        currentPage = 1; lastPage = 1; perPageVal = 15; total = 0;
      }

      return {
        'items': items.map((e) => SalesTeamModel.fromJson(e)).toList(),
        'meta': SalesTeamPaginationMeta(
          currentPage: currentPage,
          lastPage: lastPage,
          perPage: perPageVal,
          total: total,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<SalesTeamDetailModel> getSalesTeamDetail(String encryption) async {
    try {
      final response = await dio.get('/sales/sales-teams/$encryption');
      return SalesTeamDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<SalesTeamDropdownData> getFormOptions() async {
    try {
      final response = await dio.get('/sales/sales-teams/form-options');
      return SalesTeamDropdownData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createSalesTeam(SalesTeamFormModel formData) async {
    try {
      await dio.post('/sales/sales-teams', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> updateSalesTeam(
      String encryption, SalesTeamFormModel formData) async {
    try {
      final response = await dio.put(
        '/sales/sales-teams/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteSalesTeam(String encryption) async {
    try {
      await dio.delete('/sales/sales-teams/$encryption');
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