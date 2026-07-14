import 'package:erp_mobile_cnplus/features/accounting/coa/data/datasources/coa_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';

class CoaRepository {
  final CoaRemoteDataSource remoteDataSource;
  CoaRepository({required this.remoteDataSource});
  Future<List<CoaModel>> getCoaList({String? search}) => remoteDataSource.getCoaList(search: search);
  Future<CoaDetailModel> getCoaDetail(String enc) => remoteDataSource.getCoaDetail(enc);
  Future<CoaFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<int> getAutonumber({int? parentId, String? isHeader}) => remoteDataSource.getAutonumber(parentId: parentId, isHeader: isHeader);
  Future<bool> checkChildren(String enc) => remoteDataSource.checkChildren(enc);
  Future<void> createCoa(CoaFormModel f) => remoteDataSource.createCoa(f);
  Future<String> updateCoa(String enc, CoaFormModel f) => remoteDataSource.updateCoa(enc, f);
  Future<void> deleteCoa(String enc) => remoteDataSource.deleteCoa(enc);
}