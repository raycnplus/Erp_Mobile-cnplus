import 'package:erp_mobile_cnplus/features/inventory/location_report/data/repositories/location_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';

class GetLocationReportList {
  final LocationReportRepository repository;
  GetLocationReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
  }) => repository.getLocationReportList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
  );
}

class GetLocationReportDetail {
  final LocationReportRepository repository;
  GetLocationReportDetail(this.repository);

  Future<LocationReportDetailModel> call(String encryption) =>
      repository.getLocationReportDetail(encryption);
}

class GetLocationDetailTab {
  final LocationReportRepository repository;
  GetLocationDetailTab(this.repository);

  Future<LocationDetailPage<T>> call<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) => repository.getLocationDetailTab<T>(
    encryption: encryption,
    type: type,
    parser: parser,
    page: page,
    perPage: perPage,
  );
}

class GetLocationReportFormOptions {
  final LocationReportRepository repository;
  GetLocationReportFormOptions(this.repository);

  Future<List<WarehouseOptionModel>> call() => repository.getFormOptions();
}