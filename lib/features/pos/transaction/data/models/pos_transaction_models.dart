double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

double? _pdn(dynamic v) => v == null ? null : _pd(v);

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class PosPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  PosPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PosPaginationMeta.fromJson(Map<String, dynamic> j) => PosPaginationMeta(
        currentPage: _pi(j['current_page']) == 0 ? 1 : _pi(j['current_page']),
        lastPage:    _pi(j['last_page']) == 0 ? 1 : _pi(j['last_page']),
        perPage:     _pi(j['per_page']),
        total:       _pi(j['total']),
      );
}

class PosCashierSession {
  final int idSession;
  final String encryption;
  final int storeId;
  final String? openingTime;
  final String? closingTime;
  final double openingBalance;
  final double? closingBalance;
  final String status;
  final String? notes;
  final double cashSales;
  final double nonCashSales;
  final double totalSales;
  final int totalOrders;
  final int unpaidOrders;
  final double totalCashIn;
  final double totalCashOut;
  final double expectedBalance;
  final double? difference;

  PosCashierSession({
    required this.idSession,
    required this.encryption,
    required this.storeId,
    this.openingTime,
    this.closingTime,
    required this.openingBalance,
    this.closingBalance,
    required this.status,
    this.notes,
    required this.cashSales,
    required this.nonCashSales,
    required this.totalSales,
    required this.totalOrders,
    required this.unpaidOrders,
    required this.totalCashIn,
    required this.totalCashOut,
    required this.expectedBalance,
    this.difference,
  });

  factory PosCashierSession.fromJson(Map<String, dynamic> j) {
    final opening = _pd(j['opening_balance']);
    final cash = _pd(j['cash_sales']);
    final nonCash = _pd(j['non_cash_sales']);
    final cashIn = _pd(j['total_cash_in']);
    final cashOut = _pd(j['total_cash_out']);

    return PosCashierSession(
      idSession:      _pi(j['id_session']),
      encryption:     _ps(j['encryption']),
      storeId:        _pi(j['store_id']),
      openingTime:    j['opening_time']?.toString(),
      closingTime:    j['closing_time']?.toString(),
      openingBalance: opening,
      closingBalance: _pdn(j['closing_balance']),
      status:         _ps(j['status']),
      notes:          j['notes']?.toString(),
      cashSales:      cash,
      nonCashSales:   nonCash,
      totalSales:     j['total_sales'] == null ? cash + nonCash : _pd(j['total_sales']),
      totalOrders:    _pi(j['total_orders']),
      unpaidOrders:   _pi(j['unpaid_orders']),
      totalCashIn:    cashIn,
      totalCashOut:   cashOut,
      expectedBalance: j['expected_balance'] == null
          ? opening + cash + cashIn - cashOut
          : _pd(j['expected_balance']),
      difference: _pdn(j['difference']),
    );
  }

  bool get isOpen => status.toUpperCase() == 'OPEN';

  Duration get duration {
    final start = openingTime == null ? null : DateTime.tryParse(openingTime!);
    if (start == null) return Duration.zero;
    final end = closingTime == null ? null : DateTime.tryParse(closingTime!);
    return (end ?? DateTime.now()).difference(start);
  }
}

class PosCurrentSession {
  final bool hasActiveSession;
  final PosCashierSession? session;

  PosCurrentSession({required this.hasActiveSession, this.session});

  factory PosCurrentSession.fromJson(Map<String, dynamic> d) => PosCurrentSession(
        hasActiveSession: d['has_active_session'] == true,
        session: d['session'] is Map<String, dynamic>
            ? PosCashierSession.fromJson(d['session'] as Map<String, dynamic>)
            : null,
      );
}

class PosCategory {
  final int idCategory;
  final String name;

  PosCategory({required this.idCategory, required this.name});

  factory PosCategory.fromJson(Map<String, dynamic> j) => PosCategory(
        idCategory: _pi(j['id_product_category']),
        name:       _ps(j['product_category_name']),
      );
}

class PosCustomer {
  final int idCustomer;
  final String name;
  final String email;
  final String phone;
  final String address;

  PosCustomer({
    required this.idCustomer,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory PosCustomer.fromJson(Map<String, dynamic> j) => PosCustomer(
        idCustomer: _pi(j['id_customer']),
        name:       _ps(j['customer_name']),
        email:      _ps(j['email']),
        phone:      _ps(j['phone_no']),
        address:    _ps(j['address']),
      );

  @override bool operator ==(Object o) => o is PosCustomer && o.idCustomer == idCustomer;
  @override int get hashCode => idCustomer.hashCode;
}

class PosStoreInfo {
  final int idStore;
  final String storeName;

  PosStoreInfo({required this.idStore, required this.storeName});

  factory PosStoreInfo.fromJson(Map<String, dynamic> j) => PosStoreInfo(
        idStore:   _pi(j['id_store']),
        storeName: _ps(j['store_name']),
      );
}

class PosFormOptions {
  final List<PosCategory> categories;
  final List<PosCustomer> customers;
  final String? defaultPrinter;
  final List<String> paymentMethods;
  final PosStoreInfo? store;
  final PosCashierSession? activeSession;

  PosFormOptions({
    required this.categories,
    required this.customers,
    this.defaultPrinter,
    required this.paymentMethods,
    this.store,
    this.activeSession,
  });

  factory PosFormOptions.fromJson(Map<String, dynamic> d) => PosFormOptions(
        categories: (d['categories'] as List? ?? [])
            .map((e) => PosCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
        customers: (d['customers'] as List? ?? [])
            .map((e) => PosCustomer.fromJson(e as Map<String, dynamic>))
            .toList(),
        defaultPrinter: d['default_printer']?.toString(),
        paymentMethods: (d['payment_method_list'] as List? ?? []).map((e) => e.toString()).toList(),
        store: d['store'] is Map<String, dynamic>
            ? PosStoreInfo.fromJson(d['store'] as Map<String, dynamic>)
            : null,
        activeSession: d['active_session'] is Map<String, dynamic>
            ? PosCashierSession.fromJson(d['active_session'] as Map<String, dynamic>)
            : null,
      );
}

class PosProduct {
  final int idProduct;
  final String name;
  final String code;
  final String? imageUrl;
  final double salesPrice;
  final int? idCategory;
  final String categoryName;
  final int onHand;

  PosProduct({
    required this.idProduct,
    required this.name,
    required this.code,
    this.imageUrl,
    required this.salesPrice,
    this.idCategory,
    required this.categoryName,
    required this.onHand,
  });

  factory PosProduct.fromJson(Map<String, dynamic> j) => PosProduct(
        idProduct:    _pi(j['id_product']),
        name:         _ps(j['product_name']),
        code:         _ps(j['product_code']),
        imageUrl:     j['image_url']?.toString(),
        salesPrice:   _pd(j['sales_price']),
        idCategory:   j['product_category'] == null ? null : _pi(j['product_category']),
        categoryName: _ps(j['product_category_name']),
        onHand:       _pi(j['on_hand']),
      );

  PosProduct copyWith({int? onHand, double? salesPrice}) => PosProduct(
        idProduct:    idProduct,
        name:         name,
        code:         code,
        imageUrl:     imageUrl,
        salesPrice:   salesPrice ?? this.salesPrice,
        idCategory:   idCategory,
        categoryName: categoryName,
        onHand:       onHand ?? this.onHand,
      );
}

class PosStockInfo {
  final int idProduct;
  final int stock;
  final double salesPrice;

  PosStockInfo({required this.idProduct, required this.stock, required this.salesPrice});

  factory PosStockInfo.fromJson(Map<String, dynamic> j) => PosStockInfo(
        idProduct:  _pi(j['id_product']),
        stock:      _pi(j['stock']),
        salesPrice: _pd(j['sales_price']),
      );
}

class PosCartLine {
  PosProduct product;
  int qty;

  PosCartLine({required this.product, required this.qty});

  double get subtotal => product.salesPrice * qty;
}

class PosMidtransPayment {
  final String snapToken;
  final String redirectUrl;
  final String orderId;
  final double totalAmount;

  PosMidtransPayment({
    required this.snapToken,
    required this.redirectUrl,
    required this.orderId,
    required this.totalAmount,
  });

  factory PosMidtransPayment.fromJson(Map<String, dynamic> j) => PosMidtransPayment(
        snapToken:   _ps(j['snap_token']),
        redirectUrl: _ps(j['redirect_url']),
        orderId:     _ps(j['order_id']),
        totalAmount: _pd(j['total_amount']),
      );
}

class PosPaymentStatus {
  final String orderId;
  final String status;
  final bool paid;
  final bool valid;

  PosPaymentStatus({
    required this.orderId,
    required this.status,
    required this.paid,
    required this.valid,
  });

  factory PosPaymentStatus.fromJson(Map<String, dynamic> j) => PosPaymentStatus(
        orderId: _ps(j['order_id']),
        status:  _ps(j['status']),
        paid:    j['paid'] == true,
        valid:   j['valid'] != false,
      );
}

class PosSavedItem {
  final String productCode;
  final String productName;
  final double qty;
  final double price;
  final double subtotal;

  PosSavedItem({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory PosSavedItem.fromJson(Map<String, dynamic> j) {
    final name = _ps(j['product']?['product_name']);
    return PosSavedItem(
      productCode: _ps(j['product']?['product_code']),
      productName: name.isEmpty ? '-' : name,
      qty:         _pd(j['qty']),
      price:       _pd(j['price']),
      subtotal:    _pd(j['subtotal']),
    );
  }
}

class PosSavedTransaction {
  final int idTransaction;
  final String encryption;
  final String transactionCode;
  final String? transactionDate;
  final String paymentMethod;
  final double totalAmount;
  final double paidAmount;
  final double changeAmount;
  final String status;
  final String customerName;
  final String storeName;
  final List<PosSavedItem> items;

  PosSavedTransaction({
    required this.idTransaction,
    required this.encryption,
    required this.transactionCode,
    this.transactionDate,
    required this.paymentMethod,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.status,
    required this.customerName,
    required this.storeName,
    required this.items,
  });

  factory PosSavedTransaction.fromJson(Map<String, dynamic> d) => PosSavedTransaction(
        idTransaction:   _pi(d['id_transaction']),
        encryption:      _ps(d['encryption']),
        transactionCode: _ps(d['transaction_code']),
        transactionDate: d['transaction_date']?.toString(),
        paymentMethod:   _ps(d['payment_method']),
        totalAmount:     _pd(d['total_amount']),
        paidAmount:      _pd(d['paid_amount']),
        changeAmount:    _pd(d['change_amount']),
        status:          _ps(d['status']),
        customerName:    _ps(d['customer']?['customer_name']),
        storeName:       _ps(d['store']?['store_name']),
        items: (d['details'] as List? ?? [])
            .map((e) => PosSavedItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  bool get isPaid => status.toUpperCase() == 'PAID';

  PosSavedTransaction copyWith({String? status, double? paidAmount}) => PosSavedTransaction(
        idTransaction:   idTransaction,
        encryption:      encryption,
        transactionCode: transactionCode,
        transactionDate: transactionDate,
        paymentMethod:   paymentMethod,
        totalAmount:     totalAmount,
        paidAmount:      paidAmount ?? this.paidAmount,
        changeAmount:    changeAmount,
        status:          status ?? this.status,
        customerName:    customerName,
        storeName:       storeName,
        items:           items,
      );
}

class PosCashMovement {
  final int idMovement;
  final String encryption;
  final String movementType;
  final double amount;
  final String? notes;
  final String? createdAt;

  PosCashMovement({
    required this.idMovement,
    required this.encryption,
    required this.movementType,
    required this.amount,
    this.notes,
    this.createdAt,
  });

  factory PosCashMovement.fromJson(Map<String, dynamic> j) => PosCashMovement(
        idMovement:   _pi(j['id_movement']),
        encryption:   _ps(j['encryption']),
        movementType: _ps(j['movement_type']),
        amount:       _pd(j['amount']),
        notes:        j['notes']?.toString(),
        createdAt:    j['created_at']?.toString(),
      );

  bool get isIn => movementType.toUpperCase() == 'IN';
}