import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/datasources/expired_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/models/expired_report_models.dart';

class ExpiredReportRepository {
  final ExpiredReportRemoteDataSource remoteDataSource;
  ExpiredReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getExpiredReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    String? dateFrom,
    String? dateTo,
    String? expiryStatus,
  }) => remoteDataSource.getExpiredReportList(
    page: page,
    perPage: perPage,
    search: search,
    idWarehouse: idWarehouse,
    idLocation: idLocation,
    dateFrom: dateFrom,
    dateTo: dateTo,
  );

  Future<Map<String, dynamic>> getFormOptions() =>
      remoteDataSource.getFormOptions();

  Future<List<ExpiredLocationOption>> getLocationsByWarehouse(
    int idWarehouse,
  ) => remoteDataSource.getLocationsByWarehouse(idWarehouse);
}
