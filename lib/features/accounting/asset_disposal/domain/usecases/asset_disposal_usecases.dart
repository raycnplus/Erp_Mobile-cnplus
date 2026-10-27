import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/repositories/asset_disposal_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';

class GetAssetDisposalList {
  final AssetDisposalRepository r;

  GetAssetDisposalList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetAssetDisposalDetail {
  final AssetDisposalRepository r;

  GetAssetDisposalDetail(this.r);

  Future<AssetDisposalDetailModel> call(String enc) => r.getDetail(enc);
}

class GetAssetDisposalFormOptions {
  final AssetDisposalRepository r;

  GetAssetDisposalFormOptions(this.r);

  Future<AssetDisposalFormOptions> call() => r.getFormOptions();
}

class SaveAssetDisposal {
  final AssetDisposalRepository r;

  SaveAssetDisposal(this.r);

  Future<String> call(AssetDisposalFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f);
    return r.store(f);
  }
}

class ConfirmAssetDisposal {
  final AssetDisposalRepository r;

  ConfirmAssetDisposal(this.r);

  Future<String> call(String enc) => r.confirm(enc);
}

class PostAssetDisposal {
  final AssetDisposalRepository r;

  PostAssetDisposal(this.r);

  Future<String> call(String enc) => r.post(enc);
}

class CancelAssetDisposal {
  final AssetDisposalRepository r;

  CancelAssetDisposal(this.r);

  Future<String> call(String enc, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(enc, reason);
  }
}

class DeleteAssetDisposal {
  final AssetDisposalRepository r;

  DeleteAssetDisposal(this.r);

  Future<void> call(String enc) => r.delete(enc);
}