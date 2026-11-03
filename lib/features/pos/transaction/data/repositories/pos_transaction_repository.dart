import 'package:erp_mobile_cnplus/features/pos/transaction/data/datasources/pos_transaction_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';

class PosTransactionRepository {
  final PosTransactionRemoteDataSource ds;
  PosTransactionRepository(this.ds);

  Future<PosCurrentSession> getCurrentSession(int idStore) => ds.getCurrentSession(idStore);

  Future<PosCashierSession> openSession(int idStore, double openingBalance) =>
      ds.openSession(idStore, openingBalance);

  Future<PosCashierSession> getCloseSummary(String enc) => ds.getCloseSummary(enc);

  Future<PosCashierSession> closeSession(
    String enc, {
    required double closingBalance,
    String? notes,
  }) => ds.closeSession(enc, closingBalance: closingBalance, notes: notes);

  Future<PosFormOptions> getFormOptions(int idStore) => ds.getFormOptions(idStore);

  Future<Map<String, dynamic>> getProducts(
    int idStore, {
    int page = 1,
    int perPage = 20,
    int? idCategory,
    String? search,
    bool inStockOnly = false,
  }) => ds.getProducts(
        idStore,
        page: page,
        perPage: perPage,
        idCategory: idCategory,
        search: search,
        inStockOnly: inStockOnly,
      );

  Future<List<PosStockInfo>> pollStock(int idStore, List<int> ids) => ds.pollStock(idStore, ids);

  Future<PosMidtransPayment> createMidtransPayment(
    int idStore, {
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) => ds.createMidtransPayment(idStore, paymentMethod: paymentMethod, items: items);

  Future<PosSavedTransaction> saveTransaction(
    int idStore, {
    required String paymentMethod,
    int? idCustomer,
    double? paidAmount,
    String? midtransOrderId,
    required List<Map<String, dynamic>> items,
  }) => ds.saveTransaction(
        idStore,
        paymentMethod: paymentMethod,
        idCustomer: idCustomer,
        paidAmount: paidAmount,
        midtransOrderId: midtransOrderId,
        items: items,
      );

  Future<PosPaymentStatus> checkPaymentStatus(String orderId) => ds.checkPaymentStatus(orderId);

  Future<String> sendReceiptEmail(
    int idStore, {
    required String email,
    required String receipt,
  }) => ds.sendReceiptEmail(idStore, email: email, receipt: receipt);

  Future<PosCashMovement> createCashMovement(
    int idStore, {
    required String type,
    required double amount,
    String? notes,
  }) => ds.createCashMovement(idStore, type: type, amount: amount, notes: notes);

  Future<void> deleteCashMovement(String enc) => ds.deleteCashMovement(enc);
}