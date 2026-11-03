import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/datasources/transaction_history_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/models/transaction_history_models.dart';

class TransactionHistoryRepository {
  final TransactionHistoryRemoteDataSource ds;
  TransactionHistoryRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) => ds.getList(
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        status: status,
        storeIds: storeIds,
        search: search,
      );

  Future<TransactionHistoryFormOptions> getFormOptions() => ds.getFormOptions();

  Future<TransactionHistoryDetail> getDetail(String enc) => ds.getDetail(enc);

  HistoryExportUrlInfo getExportListUrl({
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) => ds.getExportListUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        status: status,
        storeIds: storeIds,
        search: search,
      );

  HistoryExportUrlInfo getExportDetailUrl(String enc) => ds.getExportDetailUrl(enc);
}