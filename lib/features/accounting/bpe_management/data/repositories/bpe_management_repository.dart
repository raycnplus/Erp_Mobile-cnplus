import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/datasources/bpe_management_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';

class BpeRepository {
  final BpeRemoteDataSource ds;
  BpeRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 15, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<BpeDetailModel> getDetail(String encryption) => ds.getDetail(encryption);

  Future<BpeModel> store(BpeFormModel f, String status) => ds.store(f, status);

  Future<BpeModel> update(String encryption, BpeFormModel f, String status) =>
      ds.update(encryption, f, status);

  Future<void> delete(String encryption) => ds.delete(encryption);

  Future<List<BpeAvailableInvoice>> searchInvoices({String? keyword, int? exceptBpeId}) =>
      ds.searchInvoices(keyword: keyword, exceptBpeId: exceptBpeId);
}