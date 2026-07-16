import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class ProjectRemoteDataSource {
  final Dio dio;

  ProjectRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getProjectList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get(
        '/master/projects',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final dynamic raw = json['data'] ?? json;

      List<dynamic> items;
      int currentPage, lastPage, perPageVal, total;

      if (raw is Map && raw['data'] is List) {
        items = raw['data'];
        currentPage = raw['current_page'] ?? 1;
        lastPage = raw['last_page'] ?? 1;
        perPageVal = raw['per_page'] ?? 15;
        total = raw['total'] ?? 0;
      } else {
        items = raw is List ? raw : [];
        currentPage = json['current_page'] ?? 1;
        lastPage = json['last_page'] ?? 1;
        perPageVal = json['per_page'] ?? 15;
        total = json['total'] ?? items.length;
      }

      return {
        'items': items.map((e) => ProjectModel.fromJson(e)).toList(),
        'meta': ProjectPaginationMeta(
          currentPage: currentPage,
          lastPage: lastPage,
          perPage: perPageVal,
          total: total,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ProjectDetailModel> getProjectDetail(String encryption) async {
    try {
      final response = await dio.get('/master/projects/$encryption');
      return ProjectDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ProjectFormOptions> getFormOptions() async {
    try {
      final response = await dio.get('/master/projects/form-options');
      return ProjectFormOptions.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> createProject(ProjectFormModel f) async {
    try {
      await dio.post('/master/projects', data: f.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> updateProject(String encryption, ProjectFormModel f) async {
    try {
      final response = await dio.put('/master/projects/$encryption', data: f.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> deleteProject(String encryption) async {
    try {
      await dio.delete('/master/projects/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}