import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/repositories/transfer_in_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';

class GetTIList {
  final TransferInRepository r;
  GetTIList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetTIDetail {
  final TransferInRepository r;
  GetTIDetail(this.r);

  Future<TransferInDetailModel> call(String enc) => r.getDetail(enc);
}

class SaveTransferIn {
  final TransferInRepository r;
  SaveTransferIn(this.r);

  Future<Map<String, dynamic>> call(String encryption, TransferInFormModel f) =>
      r.process(encryption, f, 'save');
}

class ValidateTransferIn {
  final TransferInRepository r;
  ValidateTransferIn(this.r);

  Future<Map<String, dynamic>> call(String encryption, TransferInFormModel f) =>
      r.process(encryption, f, 'validate');
}