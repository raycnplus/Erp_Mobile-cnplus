import 'package:erp_mobile_cnplus/features/pos/store/data/datasources/store_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';

class StoreRepository {
  final StoreRemoteDataSource remoteDataSource;
  StoreRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? search}) =>
      remoteDataSource.getList(page: page, perPage: perPage, search: search);
  Future<StoreDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<StoreFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<StoreModel> create(StoreFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, StoreFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
  Future<Map<String, dynamic>> selectStore(int idStore) => remoteDataSource.selectStore(idStore);
  Future<Map<String, dynamic>> verifyPin(String enc, String pin) => remoteDataSource.verifyPin(enc, pin);
}