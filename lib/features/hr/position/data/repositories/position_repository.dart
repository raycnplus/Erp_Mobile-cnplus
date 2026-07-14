import 'package:erp_mobile_cnplus/features/hr/position/data/datasources/position_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/models/position_models.dart';

class PositionRepository {
  final PositionRemoteDataSource remoteDataSource;
  PositionRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getPositionList({int page = 1, int perPage = 100}) => remoteDataSource.getPositionList(page: page, perPage: perPage);
  Future<PositionDetailModel> getPositionDetail(String enc) => remoteDataSource.getPositionDetail(enc);
  Future<void> createPosition(PositionFormModel f) => remoteDataSource.createPosition(f);
  Future<String> updatePosition(String enc, PositionFormModel f) => remoteDataSource.updatePosition(enc, f);
  Future<void> deletePosition(String enc) => remoteDataSource.deletePosition(enc);
}