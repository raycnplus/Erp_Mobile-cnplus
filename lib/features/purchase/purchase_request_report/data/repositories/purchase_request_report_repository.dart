import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/datasources/purchase_request_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/models/purchase_request_report_models.dart';

class PurchaseRequestReportRepository {
  final PurchaseRequestReportRemoteDataSource remoteDataSource;
  PurchaseRequestReportRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getPurchaseRequestReportList({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idWarehouse,
    int? idLocation,
    int? requestedBy,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) => remoteDataSource.getPurchaseRequestReportList(
        page: page,
        perPage: perPage,
        search: search,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        requestedBy: requestedBy,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

  Future<Map<String, dynamic>> getFormOptions() => remoteDataSource.getFormOptions();

  Future<List<PurchaseRequestLocationOption>> getLocationsByWarehouse(int idWarehouse) =>
      remoteDataSource.getLocationsByWarehouse(idWarehouse);
}