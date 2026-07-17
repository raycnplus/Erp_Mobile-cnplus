import 'package:erp_mobile_cnplus/features/master/product_type/data/repositories/product_type_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';

class GetProductTypeList {
  final ProductTypeRepository repository;
  GetProductTypeList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getProductTypeList(page: page, perPage: perPage);
}

class GetProductTypeDetail {
  final ProductTypeRepository repository;
  GetProductTypeDetail(this.repository);
  Future<ProductTypeDetailModel> call(String encryption) =>
      repository.getProductTypeDetail(encryption);
}

class CreateProductType {
  final ProductTypeRepository repository;
  CreateProductType(this.repository);
  Future<void> call(ProductTypeFormModel formData) async {
    if (!formData.isValid()) throw Exception('Product type name is required');
    await repository.createProductType(formData);
  }
}

class UpdateProductType {
  final ProductTypeRepository repository;
  UpdateProductType(this.repository);
  Future<String> call(String encryption, ProductTypeFormModel formData) async {
    if (!formData.isValid()) throw Exception('Product type name is required');
    return repository.updateProductType(encryption, formData);
  }
}

class DeleteProductType {
  final ProductTypeRepository repository;
  DeleteProductType(this.repository);
  Future<void> call(String encryption) =>
      repository.deleteProductType(encryption);
}