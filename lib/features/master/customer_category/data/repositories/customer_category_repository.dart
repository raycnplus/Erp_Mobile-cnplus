import 'package:erp_mobile_cnplus/features/master/customer_category/data/datasources/customer_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';

class CustomerCategoryRepository {
  final CustomerCategoryRemoteDataSource remoteDataSource;
  CustomerCategoryRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getCustomerCategoryList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getCustomerCategoryList(page: page, perPage: perPage);

  Future<CustomerCategoryDetailModel> getCustomerCategoryDetail(String encryption) =>
      remoteDataSource.getCustomerCategoryDetail(encryption);

  Future<void> createCustomerCategory(CustomerCategoryFormModel formData) =>
      remoteDataSource.createCustomerCategory(formData);

  Future<String> updateCustomerCategory(String encryption, CustomerCategoryFormModel formData) =>
      remoteDataSource.updateCustomerCategory(encryption, formData);

  Future<void> deleteCustomerCategory(String encryption) =>
      remoteDataSource.deleteCustomerCategory(encryption);
}