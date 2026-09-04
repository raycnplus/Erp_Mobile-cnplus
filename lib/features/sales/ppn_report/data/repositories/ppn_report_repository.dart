import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/datasources/ppn_report_remote_datasource.dart';

class PPNReportRepository {
  final PPNReportRemoteDataSource remoteDataSource;

  PPNReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getPPNReportList({
    int page = 1,
    int perPage = 15,
    String? reference,
    String? taxWithholder,
    String? npwp,
    String? eBupot,
    String? type,
    String? source,
    String? dateFrom,
    String? dateTo,
    String? sortField,
    String? sortDirection,
  }) {
    return remoteDataSource.getPPNReportList(
      page: page,
      perPage: perPage,
      reference: reference,
      taxWithholder: taxWithholder,
      npwp: npwp,
      eBupot: eBupot,
      type: type,
      source: source,
      dateFrom: dateFrom,
      dateTo: dateTo,
      sortField: sortField,
      sortDirection: sortDirection,
    );
  }
}