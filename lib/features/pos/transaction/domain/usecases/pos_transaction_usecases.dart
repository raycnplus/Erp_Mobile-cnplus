import 'package:erp_mobile_cnplus/features/pos/transaction/data/repositories/pos_transaction_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';

class GetPosCurrentSession {
  final PosTransactionRepository r;
  GetPosCurrentSession(this.r);
  Future<PosCurrentSession> call(int idStore) => r.getCurrentSession(idStore);
}

class OpenPosSession {
  final PosTransactionRepository r;
  OpenPosSession(this.r);
  Future<PosCashierSession> call(int idStore, double openingBalance) =>
      r.openSession(idStore, openingBalance);
}

class GetPosCloseSummary {
  final PosTransactionRepository r;
  GetPosCloseSummary(this.r);
  Future<PosCashierSession> call(String enc) => r.getCloseSummary(enc);
}

class ClosePosSession {
  final PosTransactionRepository r;
  ClosePosSession(this.r);
  Future<PosCashierSession> call(
    String enc, {
    required double closingBalance,
    String? notes,
  }) => r.closeSession(enc, closingBalance: closingBalance, notes: notes);
}

class GetPosFormOptions {
  final PosTransactionRepository r;
  GetPosFormOptions(this.r);
  Future<PosFormOptions> call(int idStore) => r.getFormOptions(idStore);
}

class GetPosProducts {
  final PosTransactionRepository r;
  GetPosProducts(this.r);
  Future<Map<String, dynamic>> call(
    int idStore, {
    int page = 1,
    int perPage = 20,
    int? idCategory,
    String? search,
    bool inStockOnly = false,
  }) => r.getProducts(
        idStore,
        page: page,
        perPage: perPage,
        idCategory: idCategory,
        search: search,
        inStockOnly: inStockOnly,
      );
}

class PollPosStock {
  final PosTransactionRepository r;
  PollPosStock(this.r);
  Future<List<PosStockInfo>> call(int idStore, List<int> ids) => r.pollStock(idStore, ids);
}

class CreatePosMidtransPayment {
  final PosTransactionRepository r;
  CreatePosMidtransPayment(this.r);
  Future<PosMidtransPayment> call(
    int idStore, {
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) => r.createMidtransPayment(idStore, paymentMethod: paymentMethod, items: items);
}

class SavePosTransaction {
  final PosTransactionRepository r;
  SavePosTransaction(this.r);
  Future<PosSavedTransaction> call(
    int idStore, {
    required String paymentMethod,
    int? idCustomer,
    double? paidAmount,
    String? midtransOrderId,
    required List<Map<String, dynamic>> items,
  }) => r.saveTransaction(
        idStore,
        paymentMethod: paymentMethod,
        idCustomer: idCustomer,
        paidAmount: paidAmount,
        midtransOrderId: midtransOrderId,
        items: items,
      );
}

class CheckPosPaymentStatus {
  final PosTransactionRepository r;
  CheckPosPaymentStatus(this.r);
  Future<PosPaymentStatus> call(String orderId) => r.checkPaymentStatus(orderId);
}

class SendPosReceiptEmail {
  final PosTransactionRepository r;
  SendPosReceiptEmail(this.r);
  Future<String> call(
    int idStore, {
    required String email,
    required String receipt,
  }) => r.sendReceiptEmail(idStore, email: email, receipt: receipt);
}

class CreatePosCashMovement {
  final PosTransactionRepository r;
  CreatePosCashMovement(this.r);
  Future<PosCashMovement> call(
    int idStore, {
    required String type,
    required double amount,
    String? notes,
  }) => r.createCashMovement(idStore, type: type, amount: amount, notes: notes);
}

class DeletePosCashMovement {
  final PosTransactionRepository r;
  DeletePosCashMovement(this.r);
  Future<void> call(String enc) => r.deleteCashMovement(enc);
}