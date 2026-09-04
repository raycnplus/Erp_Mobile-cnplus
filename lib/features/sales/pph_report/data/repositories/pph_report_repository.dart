import 'package:erp_mobile_cnplus/features/sales/pph_report/data/datasources/pph_report_remote_datasource.dart';

class PPHReportRepository {
  final PPHReportRemoteDataSource remoteDataSource;

  PPHReportRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> getPPHReportList({
    int page = 1,
    int perPage = 15,
    String? reference,
    String? paymentNumber,
    String? taxWithholder,
    String? npwp,
    String? eBupot,
    String? type,
    String? dateFrom,
    String? dateTo,
    String? sortField,
    String? sortDirection,
  }) {
    return remoteDataSource.getPPHReportList(
      page: page,
      perPage: perPage,
      reference: reference,
      paymentNumber: paymentNumber,
      taxWithholder: taxWithholder,
      npwp: npwp,
      eBupot: eBupot,
      type: type,
      dateFrom: dateFrom,
      dateTo: dateTo,
      sortField: sortField,
      sortDirection: sortDirection,
    );
  }
}