import 'package:erp_mobile_cnplus/features/hr/department/data/datasources/department_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';

class DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getDepartmentList({
    int page = 1,
    int perPage = 100,
  }) {
    return remoteDataSource.getDepartmentList(
      page: page,
      perPage: perPage,
    );
  }

  Future<DepartmentDetailModel> getDepartmentDetail(
    String encryption,
  ) {
    return remoteDataSource.getDepartmentDetail(
      encryption,
    );
  }

  Future<void> createDepartment(
    DepartmentFormModel form,
  ) {
    return remoteDataSource.createDepartment(
      form,
    );
  }

  Future<String> updateDepartment(
    String encryption,
    DepartmentFormModel form,
  ) {
    return remoteDataSource.updateDepartment(
      encryption,
      form,
    );
  }

  Future<void> deleteDepartment(
    String encryption,
  ) {
    return remoteDataSource.deleteDepartment(
      encryption,
    );
  }
}