import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';

class WorkOrderRepository {
  final WorkOrderRemoteDataSource ds;
  WorkOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 15, WorkOrderFilter? filter}) =>
      ds.getList(page: page, perPage: perPage, filter: filter);

  Future<WorkOrderFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> start(int id) => ds.start(id);
  Future<Map<String, dynamic>> pause(int id) => ds.pause(id);
  Future<Map<String, dynamic>> resume(int id) => ds.resume(id);
  Future<Map<String, dynamic>> complete(int id) => ds.complete(id);
}