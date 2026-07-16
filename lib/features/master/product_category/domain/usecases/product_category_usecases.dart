import 'package:erp_mobile_cnplus/features/master/product_category/data/repositories/product_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/models/product_category_models.dart';

class GetProductCategoryList {
  final ProductCategoryRepository repository;
  GetProductCategoryList(this.repository);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getProductCategoryList(page: page, perPage: perPage);
}

class GetProductCategoryDetail {
  final ProductCategoryRepository repository;
  GetProductCategoryDetail(this.repository);

  Future<ProductCategoryDetailModel> call(String encryption) =>
      repository.getProductCategoryDetail(encryption);
}

class CreateProductCategory {
  final ProductCategoryRepository repository;
  CreateProductCategory(this.repository);

  Future<void> call(ProductCategoryFormModel formData) async {
    if (!formData.isValid()) throw Exception('Category name is required');
    await repository.createProductCategory(formData);
  }
}

class UpdateProductCategory {
  final ProductCategoryRepository repository;
  UpdateProductCategory(this.repository);

  Future<String> call(String encryption, ProductCategoryFormModel formData) async {
    if (!formData.isValid()) throw Exception('Category name is required');
    return repository.updateProductCategory(encryption, formData);
  }
}

class DeleteProductCategory {
  final ProductCategoryRepository repository;
  DeleteProductCategory(this.repository);

  Future<void> call(String encryption) =>
      repository.deleteProductCategory(encryption);
}