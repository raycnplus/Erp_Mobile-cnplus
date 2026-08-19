import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/datasources/transfer_in_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';

class TransferInRepository {
  final TransferInRemoteDataSource ds;
  TransferInRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<TransferInDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<Map<String, dynamic>> process(String encryption, TransferInFormModel f, String action) =>
      ds.process(encryption, f, action);
}