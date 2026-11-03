import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/repositories/transaction_history_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/models/transaction_history_models.dart';

class GetTransactionHistoryList {
  final TransactionHistoryRepository r;
  GetTransactionHistoryList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) => r.getList(
        page: page,
        perPage: perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        status: status,
        storeIds: storeIds,
        search: search,
      );
}

class GetTransactionHistoryFormOptions {
  final TransactionHistoryRepository r;
  GetTransactionHistoryFormOptions(this.r);
  Future<TransactionHistoryFormOptions> call() => r.getFormOptions();
}

class GetTransactionHistoryDetail {
  final TransactionHistoryRepository r;
  GetTransactionHistoryDetail(this.r);
  Future<TransactionHistoryDetail> call(String enc) => r.getDetail(enc);
}

class GetTransactionHistoryExportUrl {
  final TransactionHistoryRepository r;
  GetTransactionHistoryExportUrl(this.r);

  HistoryExportUrlInfo call({
    String? dateFrom,
    String? dateTo,
    String? paymentMethod,
    String? status,
    String? storeIds,
    String? search,
  }) => r.getExportListUrl(
        dateFrom: dateFrom,
        dateTo: dateTo,
        paymentMethod: paymentMethod,
        status: status,
        storeIds: storeIds,
        search: search,
      );
}

class GetTransactionHistoryDetailExportUrl {
  final TransactionHistoryRepository r;
  GetTransactionHistoryDetailExportUrl(this.r);
  HistoryExportUrlInfo call(String enc) => r.getExportDetailUrl(enc);
}