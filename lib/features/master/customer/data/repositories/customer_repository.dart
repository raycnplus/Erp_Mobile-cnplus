import 'package:erp_mobile_cnplus/features/master/customer/data/datasources/customer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  CustomerRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getCustomerList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getCustomerList(page: page, perPage: perPage);

  Future<CustomerDetailModel> getCustomerDetail(String encryption) =>
      remoteDataSource.getCustomerDetail(encryption);

  Future<CustomerDropdownData> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createCustomer(CustomerFormModel formData) =>
      remoteDataSource.createCustomer(formData);

  Future<String> updateCustomer(String encryption, CustomerFormModel formData) =>
      remoteDataSource.updateCustomer(encryption, formData);

  Future<void> deleteCustomer(String encryption) =>
      remoteDataSource.deleteCustomer(encryption);
}