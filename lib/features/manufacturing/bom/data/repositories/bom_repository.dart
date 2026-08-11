import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/datasources/bom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';

class BomRepository {
  final BomRemoteDataSource remoteDataSource;
  BomRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<BomDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<BomFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> create(BomFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, BomFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}