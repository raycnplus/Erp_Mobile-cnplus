import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/repositories/fixed_asset_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';

class GetFixedAssetList {
  final FixedAssetRepository r;
  GetFixedAssetList(this.r);
  Future<Map<String, dynamic>> call({
    int page = 1, int perPage = 100, String? search, String? assetStatus,
  }) => r.getList(page: page, perPage: perPage, search: search, assetStatus: assetStatus);
}

class GetFixedAssetDetail {
  final FixedAssetRepository r;
  GetFixedAssetDetail(this.r);
  Future<FixedAssetDetailModel> call(String enc) => r.getDetail(enc);
}

class GetFixedAssetFormOptions {
  final FixedAssetRepository r;
  GetFixedAssetFormOptions(this.r);
  Future<FixedAssetFormOptions> call() => r.getFormOptions();
}

class SaveFixedAsset {
  final FixedAssetRepository r;
  SaveFixedAsset(this.r);
  Future<Map<String, dynamic>> call(FixedAssetFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class DeleteFixedAsset {
  final FixedAssetRepository r;
  DeleteFixedAsset(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}