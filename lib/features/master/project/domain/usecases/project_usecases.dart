import 'package:erp_mobile_cnplus/features/master/project/data/repositories/project_repository.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class GetProjectList {
  final ProjectRepository r;
  GetProjectList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) => r.getProjectList(page: page, perPage: perPage);
}

class GetProjectDetail {
  final ProjectRepository r;
  GetProjectDetail(this.r);
  Future<ProjectDetailModel> call(String enc) => r.getProjectDetail(enc);
}

class GetProjectFormOptions {
  final ProjectRepository r;
  GetProjectFormOptions(this.r);
  Future<ProjectFormOptions> call() => r.getFormOptions();
}

class CreateProject {
  final ProjectRepository r;
  CreateProject(this.r);
  Future<void> call(ProjectFormModel f) async {
    if (!f.isValid()) throw Exception('Project name, manager, and start date are required');
    await r.createProject(f);
  }
}

class UpdateProject {
  final ProjectRepository r;
  UpdateProject(this.r);
  Future<String> call(String enc, ProjectFormModel f) async {
    if (!f.isValid()) throw Exception('Project name, manager, and start date are required');
    return r.updateProject(enc, f);
  }
}

class DeleteProject {
  final ProjectRepository r;
  DeleteProject(this.r);
  Future<void> call(String enc) => r.deleteProject(enc);
}