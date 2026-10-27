import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/repositories/asset_depreciation_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';

class GetAssetDepreciationList {
  final AssetDepreciationRepository r;

  GetAssetDepreciationList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    int? year,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, year: year, search: search);
}

class GetAssetDepreciationDetail {
  final AssetDepreciationRepository r;

  GetAssetDepreciationDetail(this.r);

  Future<AssetDepreciationDetailModel> call(String enc) => r.getDetail(enc);
}

class GetAssetDepreciationFormOptions {
  final AssetDepreciationRepository r;

  GetAssetDepreciationFormOptions(this.r);

  Future<AssetDepreciationFormOptions> call() => r.getFormOptions();
}

class RunAssetDepreciation {
  final AssetDepreciationRepository r;

  RunAssetDepreciation(this.r);

  Future<String> call(AssetDepreciationFormModel f) => r.run(f);
}