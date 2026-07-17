import 'package:erp_mobile_cnplus/features/master/product_type/data/datasources/product_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';

class ProductTypeRepository {
  final ProductTypeRemoteDataSource remoteDataSource;
  ProductTypeRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getProductTypeList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getProductTypeList(page: page, perPage: perPage);

  Future<ProductTypeDetailModel> getProductTypeDetail(String encryption) =>
      remoteDataSource.getProductTypeDetail(encryption);

  Future<void> createProductType(ProductTypeFormModel formData) =>
      remoteDataSource.createProductType(formData);

  Future<String> updateProductType(String encryption, ProductTypeFormModel formData) =>
      remoteDataSource.updateProductType(encryption, formData);

  Future<void> deleteProductType(String encryption) =>
      remoteDataSource.deleteProductType(encryption);
}