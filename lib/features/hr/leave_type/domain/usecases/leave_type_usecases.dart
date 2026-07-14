import 'package:erp_mobile_cnplus/features/hr/leave_type/data/repositories/leave_type_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/models/leave_type_models.dart';

class GetLeaveTypeList {
  final LeaveTypeRepository r; GetLeaveTypeList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) => r.getLeaveTypeList(page: page, perPage: perPage);
}
class GetLeaveTypeDetail {
  final LeaveTypeRepository r; GetLeaveTypeDetail(this.r);
  Future<LeaveTypeDetailModel> call(String enc) => r.getLeaveTypeDetail(enc);
}
class GetLeaveTypeFormOptions {
  final LeaveTypeRepository r; GetLeaveTypeFormOptions(this.r);
  Future<LeaveTypeFormOptions> call() => r.getFormOptions();
}
class CreateLeaveType {
  final LeaveTypeRepository r; CreateLeaveType(this.r);
  Future<void> call(LeaveTypeFormModel f) async {
    if (!f.isValid()) throw Exception('Leave type name, category, allocation method, and attachment option are required');
    await r.createLeaveType(f);
  }
}
class UpdateLeaveType {
  final LeaveTypeRepository r; UpdateLeaveType(this.r);
  Future<String> call(String enc, LeaveTypeFormModel f) async {
    if (!f.isValid()) throw Exception('Leave type name, category, allocation method, and attachment option are required');
    return r.updateLeaveType(enc, f);
  }
}
class DeleteLeaveType {
  final LeaveTypeRepository r; DeleteLeaveType(this.r);
  Future<void> call(String enc) => r.deleteLeaveType(enc);
}