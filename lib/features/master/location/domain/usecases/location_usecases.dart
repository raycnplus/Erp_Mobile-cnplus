import 'package:erp_mobile_cnplus/features/master/location/data/repositories/location_repository.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';

class GetLocationList {
  final LocationRepository repository;
  GetLocationList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getLocationList(page: page, perPage: perPage);
}

class GetLocationDetail {
  final LocationRepository repository;
  GetLocationDetail(this.repository);
  Future<LocationDetailModel> call(String encryption) =>
      repository.getLocationDetail(encryption);
}

class GetLocationFormDropdownData {
  final LocationRepository repository;
  GetLocationFormDropdownData(this.repository);
  Future<LocationDropdownData> call() => repository.getFormOptions();
}

class CreateLocation {
  final LocationRepository repository;
  CreateLocation(this.repository);
  Future<void> call(LocationFormModel formData) async {
    if (!formData.isValid()) throw Exception('Location name, code, and warehouse are required');
    await repository.createLocation(formData);
  }
}

class UpdateLocation {
  final LocationRepository repository;
  UpdateLocation(this.repository);
  Future<String> call(String encryption, LocationFormModel formData) async {
    if (!formData.isValid()) throw Exception('Location name, code, and warehouse are required');
    return repository.updateLocation(encryption, formData);
  }
}

class DeleteLocation {
  final LocationRepository repository;
  DeleteLocation(this.repository);
  Future<void> call(String encryption) => repository.deleteLocation(encryption);
}