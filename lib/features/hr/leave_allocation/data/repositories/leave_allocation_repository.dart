import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/datasources/leave_allocation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';

class LeaveAllocationRepository {
  final LeaveAllocationRemoteDataSource remoteDataSource;
  LeaveAllocationRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, int? year}) => remoteDataSource.getList(page: page, perPage: perPage, year: year);
  Future<LeaveAllocationDetailModel> getDetail(String enc) => remoteDataSource.getDetail(enc);
  Future<LeaveAllocationFormOptions> getFormOptions() => remoteDataSource.getFormOptions();
  Future<void> create(LeaveAllocationFormModel f) => remoteDataSource.create(f);
  Future<String> update(String enc, LeaveAllocationFormModel f) => remoteDataSource.update(enc, f);
  Future<void> delete(String enc) => remoteDataSource.delete(enc);
}