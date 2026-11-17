import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/repositories/warehouse_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/models/warehouse_report_models.dart';

class GetWarehouseReportList {
  final WarehouseReportRepository repository;
  GetWarehouseReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
  }) => repository.getWarehouseReportList(
    page: page,
    perPage: perPage,
    search: search,
  );
}

class GetWarehouseReportDetail {
  final WarehouseReportRepository repository;
  GetWarehouseReportDetail(this.repository);

  Future<WarehouseReportDetailModel> call(String encryption) =>
      repository.getWarehouseReportDetail(encryption);
}

class GetWarehouseDetailTab {
  final WarehouseReportRepository repository;
  GetWarehouseDetailTab(this.repository);

  Future<WarehouseDetailPage<T>> call<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) => repository.getWarehouseDetailTab<T>(
    encryption: encryption,
    type: type,
    parser: parser,
    page: page,
    perPage: perPage,
  );
}