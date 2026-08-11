import 'package:erp_mobile_cnplus/features/pos/store/data/repositories/store_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';

class GetStoreList {
  final StoreRepository r;

  GetStoreList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
  }) => r.getList(page: page, perPage: perPage, search: search);
}

class GetStoreDetail {
  final StoreRepository r;

  GetStoreDetail(this.r);

  Future<StoreDetailModel> call(String enc) => r.getDetail(enc);
}

class GetStoreOptions {
  final StoreRepository r;

  GetStoreOptions(this.r);

  Future<StoreFormOptions> call() => r.getFormOptions();
}

class CreateStore {
  final StoreRepository r;

  CreateStore(this.r);

  Future<StoreModel> call(StoreFormModel f) {
    if (!f.isValid()) throw Exception('All fields are required');
    return r.create(f);
  }
}

class UpdateStore {
  final StoreRepository r;

  UpdateStore(this.r);

  Future<String> call(String enc, StoreFormModel f) {
    if (!f.isValid()) throw Exception('All fields are required');
    return r.update(enc, f);
  }
}

class DeleteStore {
  final StoreRepository r;

  DeleteStore(this.r);

  Future<void> call(String enc) => r.delete(enc);
}

class SelectStore {
  final StoreRepository r;

  SelectStore(this.r);

  Future<Map<String, dynamic>> call(int id) => r.selectStore(id);
}

class VerifyStorePin {
  final StoreRepository r;

  VerifyStorePin(this.r);

  Future<Map<String, dynamic>> call(String enc, String pin) =>
      r.verifyPin(enc, pin);
}