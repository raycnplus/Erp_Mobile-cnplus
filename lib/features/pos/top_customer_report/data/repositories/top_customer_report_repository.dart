import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/datasources/top_customer_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/models/top_customer_report_models.dart';

class TopCustomerReportRepository {
  final TopCustomerReportRemoteDataSource ds;
  TopCustomerReportRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? idStore,
    String? search,
  }) => ds.getList(
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        idStore: idStore,
        search: search,
      );

  Future<TopCustomerReportFormOptions> getFormOptions() => ds.getFormOptions();
}