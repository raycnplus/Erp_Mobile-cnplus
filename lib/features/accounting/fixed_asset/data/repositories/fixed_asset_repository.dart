import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/datasources/fixed_asset_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';

class FixedAssetRepository {
  final FixedAssetRemoteDataSource ds;
  FixedAssetRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1, int perPage = 100, String? search, String? assetStatus,
  }) => ds.getList(page: page, perPage: perPage, search: search, assetStatus: assetStatus);

  Future<FixedAssetDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<FixedAssetFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(FixedAssetFormModel f) => ds.store(f);
  Future<Map<String, dynamic>> update(String encryption, FixedAssetFormModel f) => ds.update(encryption, f);

  Future<void> delete(String encryption) => ds.delete(encryption);
}