import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/repositories/sales_product_report_repository.dart';

class GetSalesProductReportList {
  final SalesProductReportRepository repository;

  GetSalesProductReportList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? search,
    int? idProduct,
    int? idCategory,
    String? dateFrom,
    String? dateTo,
  }) {
    return repository.getSalesProductReportList(
      page: page,
      perPage: perPage,
      search: search,
      idProduct: idProduct,
      idCategory: idCategory,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}

class GetSalesProductReportFormOptions {
  final SalesProductReportRepository repository;

  GetSalesProductReportFormOptions(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getFormOptions();
  }
}