import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/datasources/collective_leave_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';

class CollectiveLeaveRepository {
  final CollectiveLeaveRemoteDataSource remoteDataSource;
  CollectiveLeaveRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getCollectiveLeaveList({int page = 1, int perPage = 100}) => remoteDataSource.getCollectiveLeaveList(page: page, perPage: perPage);
  Future<CollectiveLeaveDetailModel> getCollectiveLeaveDetail(String enc) => remoteDataSource.getCollectiveLeaveDetail(enc);
  Future<void> createCollectiveLeave(CollectiveLeaveFormModel f) => remoteDataSource.createCollectiveLeave(f);
  Future<String> updateCollectiveLeave(String enc, CollectiveLeaveFormModel f) => remoteDataSource.updateCollectiveLeave(enc, f);
  Future<void> deleteCollectiveLeave(String enc) => remoteDataSource.deleteCollectiveLeave(enc);
}