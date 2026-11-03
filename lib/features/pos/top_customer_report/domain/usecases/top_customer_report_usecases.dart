import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/repositories/top_customer_report_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/models/top_customer_report_models.dart';

class GetTopCustomerReportList {
  final TopCustomerReportRepository r;

  GetTopCustomerReportList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? idStore,
    String? search,
  }) => r.getList(
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        idStore: idStore,
        search: search,
      );
}

class GetTopCustomerReportFormOptions {
  final TopCustomerReportRepository r;

  GetTopCustomerReportFormOptions(this.r);

  Future<TopCustomerReportFormOptions> call() => r.getFormOptions();
}