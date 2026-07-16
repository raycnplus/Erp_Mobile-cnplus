import 'package:erp_mobile_cnplus/features/master/customer/data/repositories/customer_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class GetCustomerList {
  final CustomerRepository repository;
  GetCustomerList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getCustomerList(page: page, perPage: perPage);
}

class GetCustomerDetail {
  final CustomerRepository repository;
  GetCustomerDetail(this.repository);
  Future<CustomerDetailModel> call(String encryption) =>
      repository.getCustomerDetail(encryption);
}

class GetCustomerFormDropdownData {
  final CustomerRepository repository;
  GetCustomerFormDropdownData(this.repository);
  Future<CustomerDropdownData> call() => repository.getFormOptions();
}

class CreateCustomer {
  final CustomerRepository repository;
  CreateCustomer(this.repository);
  Future<void> call(CustomerFormModel formData) async {
    if (!formData.isValid()) throw Exception('Required fields are not filled');
    await repository.createCustomer(formData);
  }
}

class UpdateCustomer {
  final CustomerRepository repository;
  UpdateCustomer(this.repository);
  Future<String> call(String encryption, CustomerFormModel formData) async {
    if (!formData.isValid()) throw Exception('Required fields are not filled');
    return repository.updateCustomer(encryption, formData);
  }
}

class DeleteCustomer {
  final CustomerRepository repository;
  DeleteCustomer(this.repository);
  Future<void> call(String encryption) => repository.deleteCustomer(encryption);
}