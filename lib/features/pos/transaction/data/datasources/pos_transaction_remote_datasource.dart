import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';

class PosTransactionRemoteDataSource {
  final Dio dio;

  static const _session = '/pos/session-mobile';
  static const _trx = '/pos/transactions-mobile';
  static const _cash = '/pos/cash-movements-mobile';

  PosTransactionRemoteDataSource(this.dio);

  Future<PosCurrentSession> getCurrentSession(int idStore) => _guard(() async {
        final r = await dio.get('$_session/current', queryParameters: {'id_store': idStore});
        return PosCurrentSession.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosCashierSession> openSession(int idStore, double openingBalance) => _guard(() async {
        final r = await dio.post('$_session/open', data: {
          'id_store': idStore,
          'opening_balance': openingBalance,
        });
        return PosCashierSession.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosCashierSession> getCloseSummary(String enc) => _guard(() async {
        final r = await dio.get('$_session/$enc/close-summary');
        return PosCashierSession.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosCashierSession> closeSession(
    String enc, {
    required double closingBalance,
    String? notes,
  }) =>
      _guard(() async {
        final r = await dio.put('$_session/$enc/close', data: {
          'closing_balance': closingBalance,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        });
        return PosCashierSession.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosFormOptions> getFormOptions(int idStore) => _guard(() async {
        final r = await dio.get('$_trx/form-options', queryParameters: {'id_store': idStore});
        return PosFormOptions.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<Map<String, dynamic>> getProducts(
    int idStore, {
    int page = 1,
    int perPage = 20,
    int? idCategory,
    String? search,
    bool inStockOnly = false,
  }) =>
      _guard<Map<String, dynamic>>(() async {
        final r = await dio.get('$_trx/products', queryParameters: {
          'id_store': idStore,
          'page': page,
          'per_page': perPage,
          if (idCategory != null) 'id_category': idCategory,
          if (search != null && search.isNotEmpty) 'search': search,
          if (inStockOnly) 'in_stock_only': 1,
        });
        final pd = r.data['data'] as Map<String, dynamic>;
        return {
          'items': (pd['data'] as List)
              .map((e) => PosProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
          'meta': PosPaginationMeta.fromJson(pd),
        };
      });

  Future<List<PosStockInfo>> pollStock(int idStore, List<int> ids) => _guard(() async {
        final r = await dio.get('$_trx/stock-poll', queryParameters: {
          'id_store': idStore,
          'ids': ids,
        });
        return (r.data['data'] as List)
            .map((e) => PosStockInfo.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  Future<PosMidtransPayment> createMidtransPayment(
    int idStore, {
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) =>
      _guard(() async {
        final r = await dio.post('$_trx/midtrans-payment', data: {
          'id_store': idStore,
          'payment_method': paymentMethod,
          'items': items,
        });
        return PosMidtransPayment.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosSavedTransaction> saveTransaction(
    int idStore, {
    required String paymentMethod,
    int? idCustomer,
    double? paidAmount,
    String? midtransOrderId,
    required List<Map<String, dynamic>> items,
  }) =>
      _guard(() async {
        final r = await dio.post(_trx, data: {
          'id_store': idStore,
          'payment_method': paymentMethod,
          if (idCustomer != null) 'id_customer': idCustomer,
          if (paidAmount != null) 'paid_amount': paidAmount,
          if (midtransOrderId != null) 'midtrans_order_id': midtransOrderId,
          'items': items,
        });
        return PosSavedTransaction.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<PosPaymentStatus> checkPaymentStatus(String orderId) => _guard(() async {
        final r = await dio.get('$_trx/status/$orderId');
        return PosPaymentStatus.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<String> sendReceiptEmail(
    int idStore, {
    required String email,
    required String receipt,
  }) =>
      _guard(() async {
        final r = await dio.post('$_trx/send-receipt', data: {
          'id_store': idStore,
          'email': email,
          'receipt': receipt,
        });
        return r.data['message']?.toString() ?? 'Receipt sent';
      });

  Future<PosCashMovement> createCashMovement(
    int idStore, {
    required String type,
    required double amount,
    String? notes,
  }) =>
      _guard(() async {
        final r = await dio.post(_cash, data: {
          'id_store': idStore,
          'movement_type': type,
          'amount': amount,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        });
        return PosCashMovement.fromJson(r.data['data'] as Map<String, dynamic>);
      });

  Future<void> deleteCashMovement(String enc) => _guard<void>(() async {
        await dio.delete('$_cash/$enc');
      });

  Future<T> _guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) {
    final d = e.response?.data;
    if (d is Map) {
      final errors = d['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        if (first != null) return first.toString();
      }
      if (d['message'] != null) return d['message'].toString();
    }
    return d?.toString() ?? 'Network error';
  }
}