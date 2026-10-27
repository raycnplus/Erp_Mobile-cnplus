import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/repositories/asset_movement_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';

class GetAssetMovementList {
  final AssetMovementRepository r;
  GetAssetMovementList(this.r);
  Future<Map<String, dynamic>> call({
    int page = 1, int perPage = 100, String? search, String? startDate, String? endDate,
  }) => r.getList(page: page, perPage: perPage, search: search, startDate: startDate, endDate: endDate);
}

class GetAssetMovementDetail {
  final AssetMovementRepository r;
  GetAssetMovementDetail(this.r);
  Future<AssetMovementDetailModel> call(String enc) => r.getDetail(enc);
}

class GetAssetMovementFormOptions {
  final AssetMovementRepository r;
  GetAssetMovementFormOptions(this.r);
  Future<AssetMovementFormOptions> call() => r.getFormOptions();
}

class SaveAssetMovement {
  final AssetMovementRepository r;
  SaveAssetMovement(this.r);
  Future<Map<String, dynamic>> call(AssetMovementFormModel f) => r.store(f);
}