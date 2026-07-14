import 'package:erp_mobile_cnplus/features/hr/leave_request/data/datasources/leave_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';

class LeaveRequestRepository {
  final LeaveRequestRemoteDataSource remoteDataSource;
  LeaveRequestRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status}) => remoteDataSource.getList(page: page, perPage: perPage, status: status);
  Future<LeaveRequestDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<LeaveRequestFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<String> create(LeaveRequestFormModel f, {String status = 'save'}) => remoteDataSource.create(f, status: status);
  Future<String> update(int idLeaveRequest, LeaveRequestFormModel f, {String status = 'save'}) => remoteDataSource.update(idLeaveRequest, f, status: status);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
  Future<void> approve(int id) => remoteDataSource.approve(id);
  Future<void> reject(int id, {String? notes}) => remoteDataSource.reject(id, notes: notes);
}