import 'dart:async';
import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/domain/usecases/pos_transaction_usecases.dart';

class PosSaleController extends ChangeNotifier {
  final GetPosFormOptions getFormOptionsUC;
  final GetPosProducts getProductsUC;
  final PollPosStock pollStockUC;
  final CreatePosMidtransPayment createPaymentUC;
  final SavePosTransaction saveTransactionUC;
  final CheckPosPaymentStatus checkStatusUC;
  final SendPosReceiptEmail sendReceiptUC;

  PosSaleController({
    required this.getFormOptionsUC,
    required this.getProductsUC,
    required this.pollStockUC,
    required this.createPaymentUC,
    required this.saveTransactionUC,
    required this.checkStatusUC,
    required this.sendReceiptUC,
  });

  static const int _perPage = 20;
  static const int _maxPolls = 40; 

  int? _idStore;
  String _storeName = '';

  PosFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  String? _optionsError;

  List<PosProduct> _products = [];
  int _productPage = 1;
  int _productLastPage = 1;
  bool _isLoadingProducts = false;
  bool _isLoadingMore = false;
  String? _productError;
  String _search = '';
  int? _idCategory;
  bool _inStockOnly = false;
  int _productReq = 0;

  final Map<int, PosCartLine> _cart = {};
  PosCustomer? _customer;

  String _paymentMethod = 'CASH';
  bool _isProcessing = false;
  bool _isPolling = false;
  bool _cancelPolling = false;
  String? _paymentError;
  PosMidtransPayment? _midtrans;
  PosSavedTransaction? _lastTransaction;
  bool _isSendingReceipt = false;

  String? _message;

  int? get idStore => _idStore;
  String get storeName => _storeName;

  String? consumeMessage() {
    final m = _message;
    _message = null;
    return m;
  }

  bool get isLoadingOptions => _isLoadingOptions;
  String? get optionsError => _optionsError;
  List<PosCategory> get categories => _formOptions?.categories ?? [];
  List<PosCustomer> get customers => _formOptions?.customers ?? [];
  String? get defaultPrinter => _formOptions?.defaultPrinter;
  List<String> get paymentMethods {
    final list = _formOptions?.paymentMethods ?? [];
    return list.isEmpty ? const ['CASH', 'QRIS', 'VA'] : list;
  }

  List<PosProduct> get products => _products;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingMore => _isLoadingMore;
  String? get productError => _productError;
  bool get hasMoreProducts => _productPage < _productLastPage;
  String get search => _search;
  int? get selectedCategoryId => _idCategory;
  bool get inStockOnly => _inStockOnly;

  List<PosCartLine> get cartLines => _cart.values.toList();
  bool get isCartEmpty => _cart.isEmpty;
  int get cartCount => _cart.values.fold(0, (s, l) => s + l.qty);
  double get cartTotal => _cart.values.fold(0.0, (s, l) => s + l.subtotal);
  int qtyInCart(int idProduct) => _cart[idProduct]?.qty ?? 0;
  PosCustomer? get customer => _customer;

  String get paymentMethod => _paymentMethod;
  bool get isProcessing => _isProcessing;
  bool get isPolling => _isPolling;
  String? get paymentError => _paymentError;
  PosMidtransPayment? get midtrans => _midtrans;
  PosSavedTransaction? get lastTransaction => _lastTransaction;
  bool get isSendingReceipt => _isSendingReceipt;

  void setStore(int idStore, String storeName) {
    if (_idStore != idStore) _resetAll();
    _idStore = idStore;
    _storeName = storeName;
  }

  void _resetAll() {
    _productReq++;
    _cancelPolling = true;
    _formOptions = null;
    _optionsError = null;
    _products = [];
    _productPage = 1;
    _productLastPage = 1;
    _isLoadingProducts = false;
    _isLoadingMore = false;
    _productError = null;
    _search = '';
    _idCategory = null;
    _inStockOnly = false;
    _cart.clear();
    _customer = null;
    _paymentMethod = 'CASH';
    _paymentError = null;
    _midtrans = null;
    _lastTransaction = null;
  }

  Future<void> init() => Future.wait([loadOptions(), loadProducts()]);

  Future<void> loadOptions() async {
    final id = _idStore;
    if (id == null) return;

    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();

    try {
      _formOptions = await getFormOptionsUC(id);
    } catch (e) {
      _optionsError = _msg(e);
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    final id = _idStore;
    if (id == null) return;

    final req = ++_productReq;
    _isLoadingProducts = true;
    _productError = null;
    notifyListeners();

    try {
      final r = await getProductsUC(
        id,
        page: 1,
        perPage: _perPage,
        idCategory: _idCategory,
        search: _search.isEmpty ? null : _search,
        inStockOnly: _inStockOnly,
      );
      if (req != _productReq) return;

      final meta = r['meta'] as PosPaginationMeta;
      _products = r['items'] as List<PosProduct>;
      _productPage = meta.currentPage;
      _productLastPage = meta.lastPage;
    } catch (e) {
      if (req != _productReq) return;
      _productError = _msg(e);
      _products = [];
    } finally {
      if (req == _productReq) {
        _isLoadingProducts = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMoreProducts() async {
    final id = _idStore;
    if (id == null || _isLoadingProducts || _isLoadingMore || !hasMoreProducts) return;

    final req = _productReq;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final r = await getProductsUC(
        id,
        page: _productPage + 1,
        perPage: _perPage,
        idCategory: _idCategory,
        search: _search.isEmpty ? null : _search,
        inStockOnly: _inStockOnly,
      );
      if (req != _productReq) return;

      final meta = r['meta'] as PosPaginationMeta;
      _products = [..._products, ...(r['items'] as List<PosProduct>)];
      _productPage = meta.currentPage;
      _productLastPage = meta.lastPage;
    } catch (e) {
      _message = _msg(e);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> setSearch(String q) {
    _search = q.trim();
    return loadProducts();
  }

  Future<void> selectCategory(int? idCategory) {
    _idCategory = idCategory;
    return loadProducts();
  }

  Future<void> setInStockOnly(bool value) {
    _inStockOnly = value;
    return loadProducts();
  }

  Future<void> refreshStock() async {
    final id = _idStore;
    if (id == null || _products.isEmpty) return;

    try {
      final ids = {
        ..._products.map((p) => p.idProduct),
        ..._cart.keys,
      }.take(200).toList();

      final stock = await pollStockUC(id, ids);
      final map = {for (final s in stock) s.idProduct: s};

      _products = _products.map((p) {
        final s = map[p.idProduct];
        return s == null ? p : p.copyWith(onHand: s.stock, salesPrice: s.salesPrice);
      }).toList();

      for (final line in _cart.values) {
        final s = map[line.product.idProduct];
        if (s != null) {
          line.product = line.product.copyWith(onHand: s.stock, salesPrice: s.salesPrice);
        }
      }
      notifyListeners();
    } catch (_) {
    }
  }

  bool addToCart(PosProduct p) {
    final line = _cart[p.idProduct];
    final next = (line?.qty ?? 0) + 1;

    if (next > p.onHand) {
      _message = 'Stock ${p.name} is not enough (stock: ${p.onHand})';
      notifyListeners();
      return false;
    }

    if (line == null) {
      _cart[p.idProduct] = PosCartLine(product: p, qty: 1);
    } else {
      line.qty = next;
    }
    notifyListeners();
    return true;
  }

  bool increment(int idProduct) {
    final line = _cart[idProduct];
    if (line == null) return false;

    if (line.qty + 1 > line.product.onHand) {
      _message = 'Stock ${line.product.name} is not enough (stock: ${line.product.onHand})';
      notifyListeners();
      return false;
    }
    line.qty++;
    notifyListeners();
    return true;
  }

  void decrement(int idProduct) {
    final line = _cart[idProduct];
    if (line == null) return;

    if (line.qty <= 1) {
      _cart.remove(idProduct);
    } else {
      line.qty--;
    }
    notifyListeners();
  }

  void removeFromCart(int idProduct) {
    _cart.remove(idProduct);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void selectCustomer(PosCustomer? c) {
    _customer = c;
    notifyListeners();
  }

  void selectPaymentMethod(String method) {
    _paymentMethod = method;
    _paymentError = null;
    notifyListeners();
  }

  List<Map<String, dynamic>> _itemsJson() => _cart.values
      .map((l) => {'id_product': l.product.idProduct, 'qty': l.qty})
      .toList();

  String _midtransMethod(String method) => method == 'QRIS' ? 'qris' : 'other';

  Future<bool> payCash(double paidAmount) async {
    if (_cart.isEmpty) return false;
    if (paidAmount < cartTotal) {
      _paymentError = 'Paid amount is less than total amount';
      notifyListeners();
      return false;
    }
    return _submit(method: 'CASH', paidAmount: paidAmount);
  }

  Future<PosMidtransPayment?> startOnlinePayment() async {
    final id = _idStore;
    if (id == null || _cart.isEmpty || _paymentMethod == 'CASH') return null;

    _isProcessing = true;
    _paymentError = null;
    notifyListeners();

    try {
      _midtrans = await createPaymentUC(
        id,
        paymentMethod: _midtransMethod(_paymentMethod),
        items: _itemsJson(),
      );
      return _midtrans;
    } catch (e) {
      _paymentError = _msg(e);
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> confirmOnlinePayment() async {
    final order = _midtrans;
    if (order == null) return false;

    final ok = await _submit(method: _paymentMethod, orderId: order.orderId);
    if (!ok) return false;
    if (_lastTransaction?.isPaid ?? false) return true;

    return _pollUntilPaid(order.orderId);
  }

  void cancelOnlinePayment() {
    _cancelPolling = true;
    _midtrans = null;
    _paymentError = null;
    notifyListeners();
  }

  Future<bool> _submit({
    required String method,
    double? paidAmount,
    String? orderId,
  }) async {
    final id = _idStore;
    if (id == null) return false;

    _isProcessing = true;
    _paymentError = null;
    notifyListeners();

    try {
      final tx = await saveTransactionUC(
        id,
        paymentMethod: method,
        idCustomer: _customer?.idCustomer,
        paidAmount: paidAmount,
        midtransOrderId: orderId,
        items: _itemsJson(),
      );
      _lastTransaction = tx;
      if (tx.isPaid) _onPaid();
      return true;
    } catch (e) {
      _paymentError = _msg(e);
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> _pollUntilPaid(String orderId) async {
    _isPolling = true;
    _cancelPolling = false;
    notifyListeners();

    try {
      for (var i = 0; i < _maxPolls; i++) {
        await Future.delayed(const Duration(seconds: 3));
        if (_cancelPolling) return false;

        final s = await checkStatusUC(orderId);

        if (s.paid) {
          final tx = _lastTransaction;
          if (tx != null) {
            _lastTransaction = tx.copyWith(status: 'PAID', paidAmount: tx.totalAmount);
          }
          _onPaid();
          return true;
        }
        if (!s.valid) {
          _paymentError = 'Payment failed or expired';
          return false;
        }
      }
      _paymentError = 'Payment is not confirmed yet. Please check again in a moment.';
      return false;
    } catch (e) {
      _paymentError = _msg(e);
      return false;
    } finally {
      _isPolling = false;
      notifyListeners();
    }
  }

  void _onPaid() {
    _cart.clear();
    _midtrans = null;
    unawaited(refreshStock());
  }

  String buildReceiptText() {
    final tx = _lastTransaction;
    if (tx == null) return '';

    final b = StringBuffer()
      ..writeln(_storeName)
      ..writeln('Transaction : ${tx.transactionCode.isEmpty ? '-' : tx.transactionCode}')
      ..writeln('Date        : ${tx.transactionDate ?? '-'}');
    if (tx.customerName.isNotEmpty) b.writeln('Customer    : ${tx.customerName}');
    b.writeln('------------------------------');

    for (final i in tx.items) {
      b
        ..writeln(i.productName)
        ..writeln('  ${formatPrice(i.qty)} x ${formatPrice(i.price)} = ${formatPrice(i.subtotal)}');
    }

    b
      ..writeln('------------------------------')
      ..writeln('Total   : Rp ${formatPrice(tx.totalAmount)}')
      ..writeln('Payment : ${tx.paymentMethod}')
      ..writeln('Paid    : Rp ${formatPrice(tx.paidAmount)}')
      ..writeln('Change  : Rp ${formatPrice(tx.changeAmount)}');

    return b.toString();
  }

  Future<String?> sendReceiptEmail(String email) async {
    final id = _idStore;
    if (id == null || _lastTransaction == null) return 'No transaction to send';

    _isSendingReceipt = true;
    notifyListeners();

    try {
      await sendReceiptUC(id, email: email, receipt: buildReceiptText());
      return null;
    } catch (e) {
      return _msg(e);
    } finally {
      _isSendingReceipt = false;
      notifyListeners();
    }
  }

  void startNewTransaction() {
    _cancelPolling = true;
    _lastTransaction = null;
    _cart.clear();
    _customer = null;
    _midtrans = null;
    _paymentError = null;
    _paymentMethod = 'CASH';
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}