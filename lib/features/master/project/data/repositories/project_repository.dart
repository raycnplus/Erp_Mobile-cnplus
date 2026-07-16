import 'package:erp_mobile_cnplus/features/master/project/data/datasources/project_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  ProjectRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getProjectList({int page = 1, int perPage = 100}) => remoteDataSource.getProjectList(page: page, perPage: perPage);
  Future<ProjectDetailModel> getProjectDetail(String enc) => remoteDataSource.getProjectDetail(enc);
  Future<ProjectFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> createProject(ProjectFormModel f) => remoteDataSource.createProject(f);
  Future<String> updateProject(String enc, ProjectFormModel f) => remoteDataSource.updateProject(enc, f);
  Future<void> deleteProject(String enc) => remoteDataSource.deleteProject(enc);
}