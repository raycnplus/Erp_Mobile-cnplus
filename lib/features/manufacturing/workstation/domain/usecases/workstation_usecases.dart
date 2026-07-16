import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/repositories/workstation_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';

class GetWorkstationList {
  final WorkstationRepository r;

  GetWorkstationList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      r.getList(page: page, perPage: perPage);
}

class GetWorkstationDetail {
  final WorkstationRepository r;

  GetWorkstationDetail(this.r);

  Future<WorkstationDetailModel> call(String enc) => r.getDetail(enc);
}

class CreateWorkstation {
  final WorkstationRepository r;

  CreateWorkstation(this.r);

  Future<void> call(WorkstationFormModel f) async {
    if (!f.isValid()) throw Exception('Name and code are required');
    await r.create(f);
  }
}

class UpdateWorkstation {
  final WorkstationRepository r;

  UpdateWorkstation(this.r);

  Future<String> call(String enc, WorkstationFormModel f) async {
    if (!f.isValid()) throw Exception('Name and code are required');
    return r.update(enc, f);
  }
}

class DeleteWorkstation {
  final WorkstationRepository r;

  DeleteWorkstation(this.r);

  Future<void> call(String enc) => r.delete(enc);
}