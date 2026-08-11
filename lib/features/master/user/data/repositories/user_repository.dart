import 'package:erp_mobile_cnplus/features/master/user/data/datasources/user_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/models/user_models.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;
  UserRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<UserDetailModel> getDetail(int id) => remoteDataSource.getDetail(id);
  Future<String> toggleStatus(int id) => remoteDataSource.toggleStatus(id);
  Future<void> delete(int id) => remoteDataSource.delete(id);
}