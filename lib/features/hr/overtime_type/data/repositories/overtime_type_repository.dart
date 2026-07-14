import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/datasources/overtime_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';

class OvertimeTypeRepository {
  final OvertimeTypeRemoteDataSource ds;
  OvertimeTypeRepository({required this.ds});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? search}) => ds.getList(page: page, perPage: perPage, search: search);
  Future<OvertimeTypeDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<List<OvertimeCategoryOption>> getFormOptions() => ds.getFormOptions();
  Future<String> create(OvertimeTypeFormModel f) => ds.create(f);
  Future<String> update(String enc, OvertimeTypeFormModel f) => ds.update(enc, f);
  Future<void> delete(String enc) => ds.delete(enc);
}