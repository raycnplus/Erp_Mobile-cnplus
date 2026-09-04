import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/repositories/salespersons_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/models/salespersons_report_models.dart';

class GetSalespersonsReportList {
  final SalespersonsReportRepository repository;

  GetSalespersonsReportList(this.repository);

  Future<List<SalespersonsReportModel>> call({
    String? dateFrom,
    String? dateTo,
    List<int>? idSalesperson,
  }) => repository.getSalespersonsReportList(
        dateFrom: dateFrom,
        dateTo: dateTo,
        idSalesperson: idSalesperson,
      );
}