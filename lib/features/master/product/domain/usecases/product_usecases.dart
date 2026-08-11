import 'package:erp_mobile_cnplus/features/master/product/data/repositories/product_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';

class GetProductList {
  final ProductRepository repository;
  GetProductList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getProductList(page: page, perPage: perPage);
}

class GetProductDetail {
  final ProductRepository repository;
  GetProductDetail(this.repository);
  Future<ProductDetailModel> call(String encryption) =>
      repository.getProductDetail(encryption);
}

class GetProductFormDropdownData {
  final ProductRepository repository;
  GetProductFormDropdownData(this.repository);
  Future<ProductDropdownData> call() => repository.getFormOptions();
}

class CreateProduct {
  final ProductRepository repository;
  CreateProduct(this.repository);
  Future<void> call(ProductFormModel formData) async {
    if (!formData.isValid()) throw Exception('Required fields are not filled');
    await repository.createProduct(formData);
  }
}

class UpdateProduct {
  final ProductRepository repository;
  UpdateProduct(this.repository);
  Future<String> call(String encryption, ProductFormModel formData) async {
    if (!formData.isValid()) throw Exception('Required fields are not filled');
    return repository.updateProduct(encryption, formData);
  }
}

class DeleteProduct {
  final ProductRepository repository;
  DeleteProduct(this.repository);
  Future<void> call(String encryption) => repository.deleteProduct(encryption);
}