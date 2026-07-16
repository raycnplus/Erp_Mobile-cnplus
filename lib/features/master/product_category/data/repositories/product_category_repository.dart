import 'package:erp_mobile_cnplus/features/master/product_category/data/datasources/product_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/models/product_category_models.dart';

class ProductCategoryRepository {
  final ProductCategoryRemoteDataSource remoteDataSource;
  ProductCategoryRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getProductCategoryList({
    int page = 1,
    int perPage = 100,
  }) =>
      remoteDataSource.getProductCategoryList(page: page, perPage: perPage);

  Future<ProductCategoryDetailModel> getProductCategoryDetail(String encryption) =>
      remoteDataSource.getProductCategoryDetail(encryption);

  Future<void> createProductCategory(ProductCategoryFormModel formData) =>
      remoteDataSource.createProductCategory(formData);

  Future<String> updateProductCategory(
          String encryption, ProductCategoryFormModel formData) =>
      remoteDataSource.updateProductCategory(encryption, formData);

  Future<void> deleteProductCategory(String encryption) =>
      remoteDataSource.deleteProductCategory(encryption);
}