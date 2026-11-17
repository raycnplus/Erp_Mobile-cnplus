import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/datasources/warehouse_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/models/warehouse_report_models.dart';

class WarehouseReportRepository {
  final WarehouseReportRemoteDataSource remoteDataSource;
  WarehouseReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getWarehouseReportList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) => remoteDataSource.getWarehouseReportList(
    page: page,
    perPage: perPage,
    search: search,
  );

  Future<WarehouseReportDetailModel> getWarehouseReportDetail(
    String encryption,
  ) => remoteDataSource.getWarehouseReportDetail(encryption);

  Future<WarehouseDetailPage<T>> getWarehouseDetailTab<T>({
    required String encryption,
    required String type,
    required T Function(Map<String, dynamic>) parser,
    int page = 1,
    int perPage = 10,
  }) => remoteDataSource.getWarehouseDetailTab<T>(
    encryption: encryption,
    type: type,
    parser: parser,
    page: page,
    perPage: perPage,
  );
}