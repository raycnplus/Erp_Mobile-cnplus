import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/repositories/collective_leave_repository.dart';

class GetCollectiveLeaveList {
  final CollectiveLeaveRepository repository;

  GetCollectiveLeaveList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getCollectiveLeaveList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetCollectiveLeaveDetail {
  final CollectiveLeaveRepository repository;

  GetCollectiveLeaveDetail(this.repository);

  Future<CollectiveLeaveDetailModel> call(
    String encryption,
  ) {
    return repository.getCollectiveLeaveDetail(
      encryption,
    );
  }
}

class CreateCollectiveLeave {
  final CollectiveLeaveRepository repository;

  CreateCollectiveLeave(this.repository);

  Future<void> call(
    CollectiveLeaveFormModel form,
  ) async {
    if (!form.isValid) {
      throw Exception(
        'Name, from date, and to date are required',
      );
    }

    await repository.createCollectiveLeave(form);
  }
}

class UpdateCollectiveLeave {
  final CollectiveLeaveRepository repository;

  UpdateCollectiveLeave(this.repository);

  Future<String> call(
    String encryption,
    CollectiveLeaveFormModel form,
  ) async {
    if (!form.isValid) {
      throw Exception(
        'Name, from date, and to date are required',
      );
    }

    return repository.updateCollectiveLeave(
      encryption,
      form,
    );
  }
}

class DeleteCollectiveLeave {
  final CollectiveLeaveRepository repository;

  DeleteCollectiveLeave(this.repository);

  Future<void> call(
    String encryption,
  ) {
    return repository.deleteCollectiveLeave(
      encryption,
    );
  }
}