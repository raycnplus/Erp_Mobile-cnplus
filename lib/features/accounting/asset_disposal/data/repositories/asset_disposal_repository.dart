import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/datasources/asset_disposal_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';

class AssetDisposalRepository {
  final AssetDisposalRemoteDataSource ds;

  AssetDisposalRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<AssetDisposalDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<AssetDisposalFormOptions> getFormOptions() => ds.getFormOptions();

  Future<String> store(AssetDisposalFormModel f) => ds.store(f);

  Future<String> update(String enc, AssetDisposalFormModel f) => ds.update(enc, f);

  Future<String> confirm(String enc) => ds.confirm(enc);

  Future<String> post(String enc) => ds.post(enc);

  Future<String> cancel(String enc, String reason) => ds.cancel(enc, reason);

  Future<void> delete(String enc) => ds.delete(enc);
}