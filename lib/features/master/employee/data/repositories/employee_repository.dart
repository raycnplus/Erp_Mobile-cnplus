import 'package:erp_mobile_cnplus/features/master/employee/data/datasources/employee_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';

class EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  EmployeeRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getEmployeeList({int page = 1, int perPage = 100, String? search}) => remoteDataSource.getEmployeeList(page: page, perPage: perPage, search: search);
  Future<EmployeeDetailModel> getEmployeeDetail(String enc) => remoteDataSource.getEmployeeDetail(enc);
  Future<EmployeeDropdownData> getFormOptions() => remoteDataSource.getFormOptions();
  Future<String> createEmployee(EmployeeFormModel f) => remoteDataSource.createEmployee(f);
  Future<String> updateEmployee(String enc, EmployeeFormModel f) => remoteDataSource.updateEmployee(enc, f);
  Future<void> deleteEmployee(String enc) => remoteDataSource.deleteEmployee(enc);
  Future<Map<String, String>> createUserAccount(String enc, int idRole) => remoteDataSource.createUserAccount(enc, idRole);
}