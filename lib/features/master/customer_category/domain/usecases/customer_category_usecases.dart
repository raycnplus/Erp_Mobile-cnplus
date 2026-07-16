import 'package:erp_mobile_cnplus/features/master/customer_category/data/repositories/customer_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';

class GetCustomerCategoryList {
  final CustomerCategoryRepository repository;
  GetCustomerCategoryList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getCustomerCategoryList(page: page, perPage: perPage);
}

class GetCustomerCategoryDetail {
  final CustomerCategoryRepository repository;
  GetCustomerCategoryDetail(this.repository);
  Future<CustomerCategoryDetailModel> call(String encryption) =>
      repository.getCustomerCategoryDetail(encryption);
}

class CreateCustomerCategory {
  final CustomerCategoryRepository repository;
  CreateCustomerCategory(this.repository);
  Future<void> call(CustomerCategoryFormModel formData) async {
    if (!formData.isValid()) throw Exception('Name and code are required');
    await repository.createCustomerCategory(formData);
  }
}

class UpdateCustomerCategory {
  final CustomerCategoryRepository repository;
  UpdateCustomerCategory(this.repository);
  Future<String> call(String encryption, CustomerCategoryFormModel formData) async {
    if (!formData.isValid()) throw Exception('Name and code are required');
    return repository.updateCustomerCategory(encryption, formData);
  }
}

class DeleteCustomerCategory {
  final CustomerCategoryRepository repository;
  DeleteCustomerCategory(this.repository);
  Future<void> call(String encryption) =>
      repository.deleteCustomerCategory(encryption);
}