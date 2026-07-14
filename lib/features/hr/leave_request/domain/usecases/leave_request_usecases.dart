import 'package:erp_mobile_cnplus/features/hr/leave_request/data/repositories/leave_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';

class GetLeaveRequestList {
  final LeaveRequestRepository r;

  GetLeaveRequestList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
  }) => r.getList(page: page, perPage: perPage, status: status);
}

class GetLeaveRequestDetail {
  final LeaveRequestRepository r;

  GetLeaveRequestDetail(this.r);

  Future<LeaveRequestDetailModel> call(String enc) => r.getDetail(enc);
}

class GetLeaveRequestFormOptions {
  final LeaveRequestRepository r;

  GetLeaveRequestFormOptions(this.r);

  Future<LeaveRequestFormOptions> call() => r.getFormOptions();
}

class CreateLeaveRequest {
  final LeaveRequestRepository r;

  CreateLeaveRequest(this.r);

  Future<String> call(LeaveRequestFormModel f, {String status = 'save'}) {
    if (!f.isValid()) throw Exception('Leave type and start date are required');
    return r.create(f, status: status);
  }
}

class UpdateLeaveRequest {
  final LeaveRequestRepository r;

  UpdateLeaveRequest(this.r);

  Future<String> call(
    int idLeaveRequest,
    LeaveRequestFormModel f, {
    String status = 'save',
  }) {
    if (!f.isValid()) throw Exception('Leave type and start date are required');
    return r.update(idLeaveRequest, f, status: status);
  }
}

class DeleteLeaveRequest {
  final LeaveRequestRepository r;

  DeleteLeaveRequest(this.r);

  Future<void> call(String enc) => r.delete(enc);
}

class ApproveLeaveRequest {
  final LeaveRequestRepository r;

  ApproveLeaveRequest(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectLeaveRequest {
  final LeaveRequestRepository r;

  RejectLeaveRequest(this.r);

  Future<void> call(int id, {String? notes}) => r.reject(id, notes: notes);
}