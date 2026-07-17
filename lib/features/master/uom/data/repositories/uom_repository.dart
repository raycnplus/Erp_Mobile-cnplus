import 'package:erp_mobile_cnplus/features/master/uom/data/datasources/uom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/models/uom_models.dart';

class UomRepository {
  final UomRemoteDataSource remoteDataSource;
  UomRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<UomDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<List<UomRefOption>> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> create(UomFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, UomFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}