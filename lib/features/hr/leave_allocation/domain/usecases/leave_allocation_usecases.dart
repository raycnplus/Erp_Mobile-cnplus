import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/repositories/leave_allocation_repository.dart';

class GetLeaveAllocationList {
  final LeaveAllocationRepository repository;

  GetLeaveAllocationList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    int? year,
  }) {
    return repository.getList(
      page: page,
      perPage: perPage,
      year: year,
    );
  }
}

class GetLeaveAllocationDetail {
  final LeaveAllocationRepository repository;

  GetLeaveAllocationDetail(this.repository);

  Future<LeaveAllocationDetailModel> call(String encryption) {
    return repository.getDetail(encryption);
  }
}

class GetLeaveAllocationFormOptions {
  final LeaveAllocationRepository repository;

  GetLeaveAllocationFormOptions(this.repository);

  Future<LeaveAllocationFormOptions> call() {
    return repository.getFormOptions();
  }
}

class CreateLeaveAllocation {
  final LeaveAllocationRepository repository;

  CreateLeaveAllocation(this.repository);

  Future<void> call(LeaveAllocationFormModel form) async {
    if (!form.isValid()) {
      throw Exception(
        'Name, year, leave type, and quota are required',
      );
    }

    await repository.create(form);
  }
}

class UpdateLeaveAllocation {
  final LeaveAllocationRepository repository;

  UpdateLeaveAllocation(this.repository);

  Future<String> call(
    String encryption,
    LeaveAllocationFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception(
        'Name, year, leave type, and quota are required',
      );
    }

    return repository.update(encryption, form);
  }
}

class DeleteLeaveAllocation {
  final LeaveAllocationRepository repository;

  DeleteLeaveAllocation(this.repository);

  Future<void> call(String encryption) {
    return repository.delete(encryption);
  }
}