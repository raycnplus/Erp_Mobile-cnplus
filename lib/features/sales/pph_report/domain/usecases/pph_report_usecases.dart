import 'package:erp_mobile_cnplus/features/sales/pph_report/data/repositories/pph_report_repository.dart';

class GetPPHReportList {
  final PPHReportRepository repository;

  GetPPHReportList(this.repository);

  Future<Map<String, dynamic>> call({
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
    return repository.getPPHReportList(
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