import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/repositories/overtime_type_repository.dart';

class GetOvertimeTypeList {
  final OvertimeTypeRepository repository;

  GetOvertimeTypeList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
  }) {
    return repository.getList(
      page: page,
      perPage: perPage,
      search: search,
    );
  }
}

class GetOvertimeTypeDetail {
  final OvertimeTypeRepository repository;

  GetOvertimeTypeDetail(this.repository);

  Future<OvertimeTypeDetailModel> call(
    String encryption,
  ) {
    return repository.getDetail(encryption);
  }
}

class GetOvertimeTypeFormOptions {
  final OvertimeTypeRepository repository;

  GetOvertimeTypeFormOptions(this.repository);

  Future<List<OvertimeCategoryOption>> call() {
    return repository.getFormOptions();
  }
}

class CreateOvertimeType {
  final OvertimeTypeRepository repository;

  CreateOvertimeType(this.repository);

  Future<String> call(
    OvertimeTypeFormModel form,
  ) {
    if (!form.isValid()) {
      throw Exception('Name and rate are required');
    }

    return repository.create(form);
  }
}

class UpdateOvertimeType {
  final OvertimeTypeRepository repository;

  UpdateOvertimeType(this.repository);

  Future<String> call(
    String encryption,
    OvertimeTypeFormModel form,
  ) {
    if (!form.isValid()) {
      throw Exception('Name and rate are required');
    }

    return repository.update(
      encryption,
      form,
    );
  }
}

class DeleteOvertimeType {
  final OvertimeTypeRepository repository;

  DeleteOvertimeType(this.repository);

  Future<void> call(String encryption) {
    return repository.delete(encryption);
  }
}