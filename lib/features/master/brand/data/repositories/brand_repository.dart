import 'package:erp_mobile_cnplus/features/master/brand/data/datasources/brand_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart';

class BrandRepository {
  final BrandRemoteDataSource remoteDataSource;
  BrandRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getBrandList({
    int page = 1,
    int perPage = 15,
    String? search,
  }) =>
      remoteDataSource.getBrandList(page: page, perPage: perPage, search: search);

  Future<BrandDetailModel> getBrandDetail(String encryption) =>
      remoteDataSource.getBrandDetail(encryption);

  Future<void> createBrand(BrandFormModel formData) =>
      remoteDataSource.createBrand(formData);

  Future<String> updateBrand(String encryption, BrandFormModel formData) =>
      remoteDataSource.updateBrand(encryption, formData);

  Future<void> deleteBrand(String encryption) =>
      remoteDataSource.deleteBrand(encryption);
}