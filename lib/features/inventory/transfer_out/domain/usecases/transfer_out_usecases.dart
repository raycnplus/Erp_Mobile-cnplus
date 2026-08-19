import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/repositories/transfer_out_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/models/transfer_out_models.dart';

class GetTOList {
  final TransferOutRepository r;
  GetTOList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status, String? search}) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetTODetail {
  final TransferOutRepository r;
  GetTODetail(this.r);

  Future<TransferOutDetailModel> call(String enc) => r.getDetail(enc);
}

class SaveTransferOut {
  final TransferOutRepository r;
  SaveTransferOut(this.r);

  Future<Map<String, dynamic>> call(String encryption, TransferOutFormModel f) =>
      r.process(encryption, f, 'save');
}

class ValidateTransferOut {
  final TransferOutRepository r;
  ValidateTransferOut(this.r);

  Future<Map<String, dynamic>> call(String encryption, TransferOutFormModel f) =>
      r.process(encryption, f, 'validate');
}