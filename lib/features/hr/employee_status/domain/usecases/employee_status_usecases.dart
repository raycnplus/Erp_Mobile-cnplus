import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/repositories/employee_status_repository.dart';

class GetEmployeeStatusList {
  final EmployeeStatusRepository repository;

  GetEmployeeStatusList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getStatusList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetEmployeeStatusDetail {
  final EmployeeStatusRepository repository;

  GetEmployeeStatusDetail(this.repository);

  Future<EmployeeStatusDetailModel> call(
    String encryption,
  ) {
    return repository.getStatusDetail(
      encryption,
    );
  }
}

class CreateEmployeeStatus {
  final EmployeeStatusRepository repository;

  CreateEmployeeStatus(this.repository);

  Future<void> call(
    EmployeeStatusFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Status name is required');
    }

    await repository.createStatus(form);
  }
}

class UpdateEmployeeStatus {
  final EmployeeStatusRepository repository;

  UpdateEmployeeStatus(this.repository);

  Future<String> call(
    String encryption,
    EmployeeStatusFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Status name is required');
    }

    return repository.updateStatus(
      encryption,
      form,
    );
  }
}

class DeleteEmployeeStatus {
  final EmployeeStatusRepository repository;

  DeleteEmployeeStatus(this.repository);

  Future<void> call(
    String encryption,
  ) {
    return repository.deleteStatus(
      encryption,
    );
  }
}