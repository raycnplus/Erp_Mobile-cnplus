import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/datasources/asset_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';

class AssetCategoryRepository {
  final AssetCategoryRemoteDataSource ds;
  AssetCategoryRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1, int perPage = 100, String? search, String? depreciationMethod,
  }) => ds.getList(page: page, perPage: perPage, search: search, depreciationMethod: depreciationMethod);

  Future<AssetCategoryDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<AssetCategoryFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(AssetCategoryFormModel f) => ds.store(f);
  Future<Map<String, dynamic>> update(String encryption, AssetCategoryFormModel f) => ds.update(encryption, f);

  Future<void> delete(String encryption) => ds.delete(encryption);
}