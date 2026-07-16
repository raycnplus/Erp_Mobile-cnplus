import 'package:erp_mobile_cnplus/features/master/location/data/datasources/location_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';

class LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  LocationRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getLocationList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getLocationList(page: page, perPage: perPage);

  Future<LocationDetailModel> getLocationDetail(String encryption) =>
      remoteDataSource.getLocationDetail(encryption);

  Future<LocationDropdownData> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<void> createLocation(LocationFormModel formData) =>
      remoteDataSource.createLocation(formData);

  Future<String> updateLocation(String encryption, LocationFormModel formData) =>
      remoteDataSource.updateLocation(encryption, formData);

  Future<void> deleteLocation(String encryption) =>
      remoteDataSource.deleteLocation(encryption);
}