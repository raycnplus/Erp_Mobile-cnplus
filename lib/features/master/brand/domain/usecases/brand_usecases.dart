import 'package:erp_mobile_cnplus/features/master/brand/data/repositories/brand_repository.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart';

class GetBrandList {
  final BrandRepository repository;
  GetBrandList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 15,
    String? search,
  }) =>
      repository.getBrandList(page: page, perPage: perPage, search: search);
}

class GetBrandDetail {
  final BrandRepository repository;
  GetBrandDetail(this.repository);

  Future<BrandDetailModel> call(String encryption) =>
      repository.getBrandDetail(encryption);
}

class CreateBrand {
  final BrandRepository repository;
  CreateBrand(this.repository);

  Future<void> call(BrandFormModel formData) async {
    if (!formData.isValid()) throw Exception('Brand name is required');
    await repository.createBrand(formData);
  }
}

class UpdateBrand {
  final BrandRepository repository;
  UpdateBrand(this.repository);

  Future<String> call(String encryption, BrandFormModel formData) async {
    if (!formData.isValid()) throw Exception('Brand name is required');
    return repository.updateBrand(encryption, formData);
  }
}

class DeleteBrand {
  final BrandRepository repository;
  DeleteBrand(this.repository);

  Future<void> call(String encryption) => repository.deleteBrand(encryption);
}