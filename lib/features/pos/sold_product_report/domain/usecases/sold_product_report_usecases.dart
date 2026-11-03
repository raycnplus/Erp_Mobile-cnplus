import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/repositories/sold_product_report_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/models/sold_product_report_models.dart';

class GetSoldProductReportList {
  final SoldProductReportRepository r;

  GetSoldProductReportList(this.r);

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

class GetSoldProductReportFormOptions {
  final SoldProductReportRepository r;

  GetSoldProductReportFormOptions(this.r);

  Future<SoldProductReportFormOptions> call() => r.getFormOptions();
}