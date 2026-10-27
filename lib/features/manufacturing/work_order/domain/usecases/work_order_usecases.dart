import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/repositories/work_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';

class GetWOList {
  final WorkOrderRepository r;
  GetWOList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 15, WorkOrderFilter? filter}) =>
      r.getList(page: page, perPage: perPage, filter: filter);
}

class GetWOFormOptions {
  final WorkOrderRepository r;
  GetWOFormOptions(this.r);

  Future<WorkOrderFormOptions> call() => r.getFormOptions();
}

class StartWorkOrder {
  final WorkOrderRepository r;
  StartWorkOrder(this.r);

  Future<Map<String, dynamic>> call(int id) => r.start(id);
}

class PauseWorkOrder {
  final WorkOrderRepository r;
  PauseWorkOrder(this.r);

  Future<Map<String, dynamic>> call(int id) => r.pause(id);
}

class ResumeWorkOrder {
  final WorkOrderRepository r;
  ResumeWorkOrder(this.r);

  Future<Map<String, dynamic>> call(int id) => r.resume(id);
}

class CompleteWorkOrder {
  final WorkOrderRepository r;
  CompleteWorkOrder(this.r);

  Future<Map<String, dynamic>> call(int id) => r.complete(id);
}