import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/datasources/asset_depreciation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';

class AssetDepreciationRepository {
  final AssetDepreciationRemoteDataSource ds;

  AssetDepreciationRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    int? year,
    String? search,
  }) =>
      ds.getList(page: page, perPage: perPage, year: year, search: search);

  Future<AssetDepreciationDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<AssetDepreciationFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> run(AssetDepreciationFormModel f) => ds.run(f);
}