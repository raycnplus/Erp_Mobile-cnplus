import 'package:erp_mobile_cnplus/features/master/purchase_team/data/datasources/purchase_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/models/purchase_team_models.dart';

class PurchaseTeamRepository {
  final PurchaseTeamRemoteDataSource remoteDataSource;
  PurchaseTeamRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getPurchaseTeamList(
          {int page = 1, int perPage = 100}) =>
      remoteDataSource.getPurchaseTeamList(page: page, perPage: perPage);

  Future<PurchaseTeamDetailModel> getPurchaseTeamDetail(String encryption) =>
      remoteDataSource.getPurchaseTeamDetail(encryption);

  Future<PurchaseTeamDropdownData> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createPurchaseTeam(PurchaseTeamFormModel formData) =>
      remoteDataSource.createPurchaseTeam(formData);

  Future<String> updatePurchaseTeam(
          String encryption, PurchaseTeamFormModel formData) =>
      remoteDataSource.updatePurchaseTeam(encryption, formData);

  Future<void> deletePurchaseTeam(String encryption) =>
      remoteDataSource.deletePurchaseTeam(encryption);
}