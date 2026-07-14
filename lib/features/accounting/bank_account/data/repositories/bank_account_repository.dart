import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/datasources/bank_account_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';

class BankAccountRepository {
  final BankAccountRemoteDataSource remoteDataSource;
  BankAccountRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<BankAccountDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<BankAccountFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> create(BankAccountFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, BankAccountFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}