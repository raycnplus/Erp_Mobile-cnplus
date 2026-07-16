import 'package:erp_mobile_cnplus/features/master/vendor/data/datasources/vendor_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';

class VendorRepository {
  final VendorRemoteDataSource remoteDataSource;
  VendorRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getVendorList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getVendorList(page: page, perPage: perPage);

  Future<VendorDetailModel> getVendorDetail(String encryption) =>
      remoteDataSource.getVendorDetail(encryption);

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createVendor(VendorFormModel formData) =>
      remoteDataSource.createVendor(formData);

  Future<String> updateVendor(String encryption, VendorFormModel formData) =>
      remoteDataSource.updateVendor(encryption, formData);

  Future<void> deleteVendor(String encryption) =>
      remoteDataSource.deleteVendor(encryption);
}