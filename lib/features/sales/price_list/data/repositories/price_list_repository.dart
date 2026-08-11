import 'package:erp_mobile_cnplus/features/sales/price_list/data/datasources/price_list_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class PriceListRepository {
  final PriceListRemoteDataSource remoteDataSource;
  PriceListRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) => remoteDataSource.getList(page: page, perPage: perPage);
  Future<PriceListDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<List<PriceListProductOption>> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> create(PriceListFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, PriceListFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}