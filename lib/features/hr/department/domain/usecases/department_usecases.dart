import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/repositories/department_repository.dart';

class GetDepartmentList {
  final DepartmentRepository repository;

  GetDepartmentList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getDepartmentList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetDepartmentDetail {
  final DepartmentRepository repository;

  GetDepartmentDetail(this.repository);

  Future<DepartmentDetailModel> call(
    String encryption,
  ) {
    return repository.getDepartmentDetail(
      encryption,
    );
  }
}

class CreateDepartment {
  final DepartmentRepository repository;

  CreateDepartment(this.repository);

  Future<void> call(
    DepartmentFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Department name is required');
    }

    await repository.createDepartment(form);
  }
}

class UpdateDepartment {
  final DepartmentRepository repository;

  UpdateDepartment(this.repository);

  Future<String> call(
    String encryption,
    DepartmentFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Department name is required');
    }

    return repository.updateDepartment(
      encryption,
      form,
    );
  }
}

class DeleteDepartment {
  final DepartmentRepository repository;

  DeleteDepartment(this.repository);

  Future<void> call(
    String encryption,
  ) {
    return repository.deleteDepartment(
      encryption,
    );
  }
}