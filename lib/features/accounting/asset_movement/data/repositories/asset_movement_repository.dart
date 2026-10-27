import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/datasources/asset_movement_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';

class AssetMovementRepository {
  final AssetMovementRemoteDataSource ds;
  AssetMovementRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1, int perPage = 100, String? search, String? startDate, String? endDate,
  }) => ds.getList(page: page, perPage: perPage, search: search, startDate: startDate, endDate: endDate);

  Future<AssetMovementDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<AssetMovementFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(AssetMovementFormModel f) => ds.store(f);
}