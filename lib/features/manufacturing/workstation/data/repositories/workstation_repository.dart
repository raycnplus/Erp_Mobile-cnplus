import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/datasources/workstation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';

class WorkstationRepository {
  final WorkstationRemoteDataSource remoteDataSource;
  WorkstationRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<WorkstationDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<void> create(WorkstationFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, WorkstationFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}