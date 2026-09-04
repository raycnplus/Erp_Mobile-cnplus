import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/datasources/salespersons_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/models/salespersons_report_models.dart';

class SalespersonsReportRepository {
  final SalespersonsReportRemoteDataSource remoteDataSource;

  SalespersonsReportRepository({required this.remoteDataSource});

  Future<List<SalespersonsReportModel>> getSalespersonsReportList({
    String? dateFrom,
    String? dateTo,
    List<int>? idSalesperson,
  }) => remoteDataSource.getSalespersonsReportList(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idSalesperson: idSalesperson,
      );
}