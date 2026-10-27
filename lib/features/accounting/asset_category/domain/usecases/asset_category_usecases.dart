import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/repositories/asset_category_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';

class GetAssetCategoryList {
  final AssetCategoryRepository r;
  GetAssetCategoryList(this.r);
  Future<Map<String, dynamic>> call({
    int page = 1, int perPage = 100, String? search, String? depreciationMethod,
  }) => r.getList(page: page, perPage: perPage, search: search, depreciationMethod: depreciationMethod);
}

class GetAssetCategoryDetail {
  final AssetCategoryRepository r;
  GetAssetCategoryDetail(this.r);
  Future<AssetCategoryDetailModel> call(String enc) => r.getDetail(enc);
}

class GetAssetCategoryFormOptions {
  final AssetCategoryRepository r;
  GetAssetCategoryFormOptions(this.r);
  Future<AssetCategoryFormOptions> call() => r.getFormOptions();
}

class SaveAssetCategory {
  final AssetCategoryRepository r;
  SaveAssetCategory(this.r);
  Future<Map<String, dynamic>> call(AssetCategoryFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class DeleteAssetCategory {
  final AssetCategoryRepository r;
  DeleteAssetCategory(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}