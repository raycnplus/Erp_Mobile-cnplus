import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/repositories/store_session_report_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';

class GetStoreSessionList {
  final StoreSessionReportRepository r;
  GetStoreSessionList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? idStore,
    String? status,
  }) => r.getList(page: page, perPage: perPage, idStore: idStore, status: status);
}

class GetStoreSessionFormOptions {
  final StoreSessionReportRepository r;
  GetStoreSessionFormOptions(this.r);
  Future<StoreSessionFormOptions> call() => r.getFormOptions();
}

class GetStoreSessionDetail {
  final StoreSessionReportRepository r;
  GetStoreSessionDetail(this.r);
  Future<StoreSessionDetail> call(String enc) => r.getDetail(enc);
}

class GetStoreSessionTransactions {
  final StoreSessionReportRepository r;
  GetStoreSessionTransactions(this.r);

  Future<Map<String, dynamic>> call(
    String enc, {
    int page = 1,
    int perPage = 15,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? search,
  }) => r.getTransactions(
        enc,
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        search: search,
      );
}

class GetStoreSessionCashMovements {
  final StoreSessionReportRepository r;
  GetStoreSessionCashMovements(this.r);

  Future<Map<String, dynamic>> call(String enc, {int page = 1, int perPage = 15}) =>
      r.getCashMovements(enc, page: page, perPage: perPage);
}

class GetSessionTransactionDetail {
  final StoreSessionReportRepository r;
  GetSessionTransactionDetail(this.r);
  Future<StoreSessionTransactionDetail> call(String enc) => r.getTransactionDetail(enc);
}

class GetStoreSessionExportUrl {
  final StoreSessionReportRepository r;
  GetStoreSessionExportUrl(this.r);

  SessionExportUrlInfo call(
    String enc, {
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
  }) => r.getExportSessionUrl(enc, dateFrom: dateFrom, dateTo: dateTo, paymentMethod: paymentMethod);
}

class GetSessionTransactionExportUrl {
  final StoreSessionReportRepository r;
  GetSessionTransactionExportUrl(this.r);
  SessionExportUrlInfo call(String enc) => r.getExportTransactionUrl(enc);
}