import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/datasources/transfer_out_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/models/transfer_out_models.dart';

class TransferOutRepository {
  final TransferOutRemoteDataSource ds;
  TransferOutRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<TransferOutDetailModel> getDetail(String enc) => ds.getDetail(enc);

  Future<Map<String, dynamic>> process(String encryption, TransferOutFormModel f, String action) =>
      ds.process(encryption, f, action);
}