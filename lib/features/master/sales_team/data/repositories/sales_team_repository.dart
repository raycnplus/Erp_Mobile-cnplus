import 'package:erp_mobile_cnplus/features/master/sales_team/data/datasources/sales_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';

class SalesTeamRepository {
  final SalesTeamRemoteDataSource remoteDataSource;
  SalesTeamRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getSalesTeamList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getSalesTeamList(page: page, perPage: perPage);

  Future<SalesTeamDetailModel> getSalesTeamDetail(String encryption) =>
      remoteDataSource.getSalesTeamDetail(encryption);

  Future<SalesTeamDropdownData> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createSalesTeam(SalesTeamFormModel formData) =>
      remoteDataSource.createSalesTeam(formData);

  Future<String> updateSalesTeam(String encryption, SalesTeamFormModel formData) =>
      remoteDataSource.updateSalesTeam(encryption, formData);

  Future<void> deleteSalesTeam(String encryption) =>
      remoteDataSource.deleteSalesTeam(encryption);
}