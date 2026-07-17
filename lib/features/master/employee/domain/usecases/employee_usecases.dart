import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/repositories/employee_repository.dart';

class GetEmployeeList {
  final EmployeeRepository repository;

  GetEmployeeList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
  }) {
    return repository.getEmployeeList(
      page: page,
      perPage: perPage,
      search: search,
    );
  }
}

class GetEmployeeDetail {
  final EmployeeRepository repository;

  GetEmployeeDetail(this.repository);

  Future<EmployeeDetailModel> call(String encryptedId) {
    return repository.getEmployeeDetail(encryptedId);
  }
}

class GetEmployeeFormOptions {
  final EmployeeRepository repository;

  GetEmployeeFormOptions(this.repository);

  Future<EmployeeDropdownData> call() {
    return repository.getFormOptions();
  }
}

class CreateEmployee {
  final EmployeeRepository repository;

  CreateEmployee(this.repository);

  Future<String> call(EmployeeFormModel form) async {
    if (!form.isValid()) {
      throw Exception('Employee name is required');
    }

    return repository.createEmployee(form);
  }
}

class UpdateEmployee {
  final EmployeeRepository repository;

  UpdateEmployee(this.repository);

  Future<String> call(
    String encryptedId,
    EmployeeFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Employee name is required');
    }

    return repository.updateEmployee(
      encryptedId,
      form,
    );
  }
}

class DeleteEmployee {
  final EmployeeRepository repository;

  DeleteEmployee(this.repository);

  Future<void> call(String encryptedId) {
    return repository.deleteEmployee(encryptedId);
  }
}

class CreateEmployeeUserAccount {
  final EmployeeRepository repository;

  CreateEmployeeUserAccount(this.repository);

  Future<Map<String, String>> call(
    String encryptedId,
    int roleId,
  ) {
    return repository.createUserAccount(
      encryptedId,
      roleId,
    );
  }
}