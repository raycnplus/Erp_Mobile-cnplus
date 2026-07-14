import 'package:erp_mobile_cnplus/features/hr/leave_type/data/datasources/leave_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/models/leave_type_models.dart';

class LeaveTypeRepository {
  final LeaveTypeRemoteDataSource remoteDataSource;
  LeaveTypeRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getLeaveTypeList({int page = 1, int perPage = 100}) => remoteDataSource.getLeaveTypeList(page: page, perPage: perPage);
  Future<LeaveTypeDetailModel> getLeaveTypeDetail(String enc) => remoteDataSource.getLeaveTypeDetail(enc);
  Future<LeaveTypeFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> createLeaveType(LeaveTypeFormModel f) => remoteDataSource.createLeaveType(f);
  Future<String> updateLeaveType(String enc, LeaveTypeFormModel f) => remoteDataSource.updateLeaveType(enc, f);
  Future<void> deleteLeaveType(String enc) => remoteDataSource.deleteLeaveType(enc);
}