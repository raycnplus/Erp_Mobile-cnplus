import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/datasources/store_session_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';

class StoreSessionReportRepository {
  final StoreSessionReportRemoteDataSource ds;
  StoreSessionReportRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? idStore,
    String? status,
  }) => ds.getList(page: page, perPage: perPage, idStore: idStore, status: status);

  Future<StoreSessionFormOptions> getFormOptions() => ds.getFormOptions();

  Future<StoreSessionDetail> getDetail(String enc) => ds.getDetail(enc);

  Future<Map<String, dynamic>> getTransactions(
    String enc, {
    int page = 1,
    int perPage = 15,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? search,
  }) => ds.getTransactions(
        enc,
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        search: search,
      );

  Future<Map<String, dynamic>> getCashMovements(String enc, {int page = 1, int perPage = 15}) =>
      ds.getCashMovements(enc, page: page, perPage: perPage);

  Future<StoreSessionTransactionDetail> getTransactionDetail(String enc) => ds.getTransactionDetail(enc);

  SessionExportUrlInfo getExportSessionUrl(
    String enc, {
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
  }) => ds.getExportSessionUrl(enc, dateFrom: dateFrom, dateTo: dateTo, paymentMethod: paymentMethod);

  SessionExportUrlInfo getExportTransactionUrl(String enc) => ds.getExportTransactionUrl(enc);
}