import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/datasources/overtime_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';

class OvertimeRequestRepository {
  final OvertimeRequestRemoteDataSource ds;
  OvertimeRequestRepository({required this.ds});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status}) => ds.getList(page: page, perPage: perPage, status: status);
  Future<OvertimeRequestDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<OvertimeRequestFormOptions> getFormOptions() => ds.getFormOptions();
  Future<String> create(OvertimeRequestFormModel f, {String actionType = 'save'}) => ds.create(f, actionType: actionType);
  Future<String> update(int id, OvertimeRequestFormModel f, {String actionType = 'save'}) => ds.update(id, f, actionType: actionType);
  Future<void> delete(String enc) => ds.delete(enc);
  Future<void> approve(int id, {double? approvedHours, String? notes}) => ds.approve(id, approvedHours: approvedHours, notes: notes);
  Future<void> reject(int id, {String? notes}) => ds.reject(id, notes: notes);
}