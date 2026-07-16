import 'package:erp_mobile_cnplus/features/master/vendor/data/repositories/vendor_repository.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';

class GetVendorList {
  final VendorRepository repository;
  GetVendorList(this.repository);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getVendorList(page: page, perPage: perPage);
}

class GetVendorDetail {
  final VendorRepository repository;
  GetVendorDetail(this.repository);

  Future<VendorDetailModel> call(String encryption) =>
      repository.getVendorDetail(encryption);
}

class GetVendorFormDropdownData {
  final VendorRepository repository;
  GetVendorFormDropdownData(this.repository);

  Future<Map<String, dynamic>> call() => repository.getFormOptions();
}

class CreateVendor {
  final VendorRepository repository;
  CreateVendor(this.repository);

  Future<void> call(VendorFormModel formData) async {
    if (!formData.isValid()) throw Exception('Vendor name and code are required');
    await repository.createVendor(formData);
  }
}

class UpdateVendor {
  final VendorRepository repository;
  UpdateVendor(this.repository);

  Future<String> call(String encryption, VendorFormModel formData) async {
    if (!formData.isValid()) throw Exception('Vendor name and code are required');
    return repository.updateVendor(encryption, formData);
  }
}

class DeleteVendor {
  final VendorRepository repository;
  DeleteVendor(this.repository);

  Future<void> call(String encryption) => repository.deleteVendor(encryption);
}