import 'package:erp_mobile_cnplus/features/master/user/data/repositories/user_repository.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/models/user_models.dart';

class GetUserList {
  final UserRepository r;

  GetUserList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      r.getList(page: page, perPage: perPage);
}

class GetUserDetail {
  final UserRepository r;

  GetUserDetail(this.r);

  Future<UserDetailModel> call(int id) => r.getDetail(id);
}

class ToggleUserStatus {
  final UserRepository r;

  ToggleUserStatus(this.r);

  Future<String> call(int id) => r.toggleStatus(id);
}

class DeleteUser {
  final UserRepository r;

  DeleteUser(this.r);

  Future<void> call(int id) => r.delete(id);
}