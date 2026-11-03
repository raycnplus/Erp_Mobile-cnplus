import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/datasources/sold_product_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/models/sold_product_report_models.dart';

class SoldProductReportRepository {
  final SoldProductReportRemoteDataSource ds;
  SoldProductReportRepository(this.ds);

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

  Future<SoldProductReportFormOptions> getFormOptions() => ds.getFormOptions();
}