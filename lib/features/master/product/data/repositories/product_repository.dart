import 'package:erp_mobile_cnplus/features/master/product/data/datasources/product_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  ProductRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getProductList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getProductList(page: page, perPage: perPage);

  Future<ProductDetailModel> getProductDetail(String encryption) =>
      remoteDataSource.getProductDetail(encryption);

  Future<ProductDropdownData> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createProduct(ProductFormModel formData) =>
      remoteDataSource.createProduct(formData);

  Future<String> updateProduct(String encryption, ProductFormModel formData) =>
      remoteDataSource.updateProduct(encryption, formData);

  Future<void> deleteProduct(String encryption) =>
      remoteDataSource.deleteProduct(encryption);
}