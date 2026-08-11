import 'package:erp_mobile_cnplus/features/master/sales_team/data/repositories/sales_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';

class GetSalesTeamList {
  final SalesTeamRepository repository;
  GetSalesTeamList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getSalesTeamList(page: page, perPage: perPage);
}

class GetSalesTeamDetail {
  final SalesTeamRepository repository;
  GetSalesTeamDetail(this.repository);
  Future<SalesTeamDetailModel> call(String encryption) =>
      repository.getSalesTeamDetail(encryption);
}

class GetSalesTeamFormOptions {
  final SalesTeamRepository repository;
  GetSalesTeamFormOptions(this.repository);
  Future<SalesTeamDropdownData> call() => repository.getFormOptions();
}

class CreateSalesTeam {
  final SalesTeamRepository repository;
  CreateSalesTeam(this.repository);
  Future<void> call(SalesTeamFormModel formData) async {
    if (!formData.isValid())
      throw Exception('Team name, leader, and at least 1 member are required');
    await repository.createSalesTeam(formData);
  }
}

class UpdateSalesTeam {
  final SalesTeamRepository repository;
  UpdateSalesTeam(this.repository);
  Future<String> call(String encryption, SalesTeamFormModel formData) async {
    if (!formData.isValid())
      throw Exception('Team name, leader, and at least 1 member are required');
    return repository.updateSalesTeam(encryption, formData);
  }
}

class DeleteSalesTeam {
  final SalesTeamRepository repository;
  DeleteSalesTeam(this.repository);
  Future<void> call(String encryption) => repository.deleteSalesTeam(encryption);
}