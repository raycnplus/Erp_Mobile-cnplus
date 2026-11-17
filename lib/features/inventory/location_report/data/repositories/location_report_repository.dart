import 'package:erp_mobile_cnplus/features/inventory/location_report/data/datasources/location_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';

class LocationReportRepository {
  final LocationReportRemoteDataSource remoteDataSource;
  LocationReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getLocationReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
  }) => remoteDataSource.getLocationReportList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
  );

  Future<LocationReportDetailModel> getLocationReportDetail(
    String encryption,
  ) => remoteDataSource.getLocationReportDetail(encryption);

  Future<LocationDetailPage<T>> getLocationDetailTab<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) => remoteDataSource.getLocationDetailTab<T>(
    encryption: encryption,
    type: type,
    parser: parser,
    page: page,
    perPage: perPage,
  );

  Future<List<WarehouseOptionModel>> getFormOptions() =>
      remoteDataSource.getFormOptions();
}