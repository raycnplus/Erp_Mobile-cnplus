import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/repositories/bpe_management_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';

class GetBpeList {
  final BpeRepository r;

  GetBpeList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 15, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetBpeDetail {
  final BpeRepository r;

  GetBpeDetail(this.r);

  Future<BpeDetailModel> call(String encryption) => r.getDetail(encryption);
}

class SaveBpe {
  final BpeRepository r;

  SaveBpe(this.r);

  Future<BpeModel> call(BpeFormModel f) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, 'save');
    }
    return r.store(f, 'save');
  }
}

class ConfirmBpe {
  final BpeRepository r;

  ConfirmBpe(this.r);

  Future<BpeModel> call(BpeFormModel f) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, 'confirm');
    }
    return r.store(f, 'confirm');
  }
}

class ValidateBpe {
  final BpeRepository r;

  ValidateBpe(this.r);

  Future<BpeModel> call(BpeFormModel f) {
    if (f.idBpe == null) throw Exception('id_bpe is required to validate');
    return r.store(f, 'validate');
  }
}

class DeleteBpe {
  final BpeRepository r;

  DeleteBpe(this.r);

  Future<void> call(String encryption) => r.delete(encryption);
}

class SearchAvailableInvoices {
  final BpeRepository r;

  SearchAvailableInvoices(this.r);

  Future<List<BpeAvailableInvoice>> call({String? keyword, int? exceptBpeId}) =>
      r.searchInvoices(keyword: keyword, exceptBpeId: exceptBpeId);
}