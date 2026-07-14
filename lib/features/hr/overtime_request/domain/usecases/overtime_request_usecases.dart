import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/repositories/overtime_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';

class GetOvertimeRequestList {
  final OvertimeRequestRepository r;

  GetOvertimeRequestList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
  }) => r.getList(page: page, perPage: perPage, status: status);
}

class GetOvertimeRequestDetail {
  final OvertimeRequestRepository r;

  GetOvertimeRequestDetail(this.r);

  Future<OvertimeRequestDetailModel> call(String enc) => r.getDetail(enc);
}

class GetOvertimeRequestFormOptions {
  final OvertimeRequestRepository r;

  GetOvertimeRequestFormOptions(this.r);

  Future<OvertimeRequestFormOptions> call() => r.getFormOptions();
}

class CreateOvertimeRequest {
  final OvertimeRequestRepository r;

  CreateOvertimeRequest(this.r);

  Future<String> call(OvertimeRequestFormModel f, {String actionType = 'save'}) {
    if (f.idOvertimeType == null ||
        f.requestDate == null ||
        f.startTime == null ||
        f.endTime == null) {
      throw Exception('Please fill all required fields');
    }
    if (f.requestedHours < 3) {
      throw Exception('Minimum overtime duration is 3 hours');
    }
    return r.create(f, actionType: actionType);
  }
}

class UpdateOvertimeRequest {
  final OvertimeRequestRepository r;

  UpdateOvertimeRequest(this.r);

  Future<String> call(
    int id,
    OvertimeRequestFormModel f, {
    String actionType = 'save',
  }) {
    if (f.idOvertimeType == null ||
        f.requestDate == null ||
        f.startTime == null ||
        f.endTime == null) {
      throw Exception('Please fill all required fields');
    }
    if (f.requestedHours < 3) {
      throw Exception('Minimum overtime duration is 3 hours');
    }
    return r.update(id, f, actionType: actionType);
  }
}

class DeleteOvertimeRequest {
  final OvertimeRequestRepository r;

  DeleteOvertimeRequest(this.r);

  Future<void> call(String enc) => r.delete(enc);
}

class ApproveOvertimeRequest {
  final OvertimeRequestRepository r;

  ApproveOvertimeRequest(this.r);

  Future<void> call(int id, {double? approvedHours, String? notes}) =>
      r.approve(id, approvedHours: approvedHours, notes: notes);
}

class RejectOvertimeRequest {
  final OvertimeRequestRepository r;

  RejectOvertimeRequest(this.r);

  Future<void> call(int id, {String? notes}) => r.reject(id, notes: notes);
}