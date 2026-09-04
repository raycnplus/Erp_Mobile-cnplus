import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/repositories/ppn_report_repository.dart';

class GetPPNReportList {
  final PPNReportRepository repository;

  GetPPNReportList(this.repository);

  Future<Map<String, dynamic>> call({
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
    return repository.getPPNReportList(
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