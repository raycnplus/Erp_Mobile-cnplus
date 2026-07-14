import 'package:erp_mobile_cnplus/features/hr/employee_status/data/datasources/employee_status_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';

class EmployeeStatusRepository {
  final EmployeeStatusRemoteDataSource remoteDataSource;

  EmployeeStatusRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getStatusList({
    int page = 1,
    int perPage = 100,
  }) {
    return remoteDataSource.getStatusList(
      page: page,
      perPage: perPage,
    );
  }

  Future<EmployeeStatusDetailModel> getStatusDetail(
    String encryption,
  ) {
    return remoteDataSource.getStatusDetail(
      encryption,
    );
  }

  Future<void> createStatus(
    EmployeeStatusFormModel form,
  ) {
    return remoteDataSource.createStatus(
      form,
    );
  }

  Future<String> updateStatus(
    String encryption,
    EmployeeStatusFormModel form,
  ) {
    return remoteDataSource.updateStatus(
      encryption,
      form,
    );
  }

  Future<void> deleteStatus(
    String encryption,
  ) {
    return remoteDataSource.deleteStatus(
      encryption,
    );
  }
}