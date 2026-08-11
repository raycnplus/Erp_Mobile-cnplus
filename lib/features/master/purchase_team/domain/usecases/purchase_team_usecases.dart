import 'package:erp_mobile_cnplus/features/master/purchase_team/data/repositories/purchase_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/models/purchase_team_models.dart';

class GetPurchaseTeamList {
  final PurchaseTeamRepository repository;
  GetPurchaseTeamList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getPurchaseTeamList(page: page, perPage: perPage);
}

class GetPurchaseTeamDetail {
  final PurchaseTeamRepository repository;
  GetPurchaseTeamDetail(this.repository);
  Future<PurchaseTeamDetailModel> call(String encryption) =>
      repository.getPurchaseTeamDetail(encryption);
}

class GetPurchaseTeamFormOptions {
  final PurchaseTeamRepository repository;
  GetPurchaseTeamFormOptions(this.repository);
  Future<PurchaseTeamDropdownData> call() => repository.getFormOptions();
}

class CreatePurchaseTeam {
  final PurchaseTeamRepository repository;
  CreatePurchaseTeam(this.repository);
  Future<void> call(PurchaseTeamFormModel formData) async {
    if (!formData.isValid())
      throw Exception('Team name, leader, and at least 1 member are required');
    await repository.createPurchaseTeam(formData);
  }
}

class UpdatePurchaseTeam {
  final PurchaseTeamRepository repository;
  UpdatePurchaseTeam(this.repository);
  Future<String> call(String encryption, PurchaseTeamFormModel formData) async {
    if (!formData.isValid())
      throw Exception('Team name, leader, and at least 1 member are required');
    return repository.updatePurchaseTeam(encryption, formData);
  }
}

class DeletePurchaseTeam {
  final PurchaseTeamRepository repository;
  DeletePurchaseTeam(this.repository);
  Future<void> call(String encryption) =>
      repository.deletePurchaseTeam(encryption);
}