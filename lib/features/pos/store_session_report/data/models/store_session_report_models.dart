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

class StoreSessionPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  StoreSessionPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory StoreSessionPaginationMeta.fromJson(Map<String, dynamic> j) => StoreSessionPaginationMeta(
        currentPage: _pi(j['current_page']) == 0 ? 1 : _pi(j['current_page']),
        lastPage:    _pi(j['last_page']) == 0 ? 1 : _pi(j['last_page']),
        perPage:     _pi(j['per_page']),
        total:       _pi(j['total']),
      );
}

class StoreSessionItem {
  final int idSession;
  final String encryption;
  final String idSessionLabel;
  final String storeName;
  final String openedBy;
  final String? openingTime;
  final String? closingTime;
  final double openingBalance;
  final double? closingBalance;
  final double totalSales;
  final String status;

  StoreSessionItem({
    required this.idSession,
    required this.encryption,
    required this.idSessionLabel,
    required this.storeName,
    required this.openedBy,
    this.openingTime,
    this.closingTime,
    required this.openingBalance,
    this.closingBalance,
    required this.totalSales,
    required this.status,
  });

  factory StoreSessionItem.fromJson(Map<String, dynamic> j) => StoreSessionItem(
        idSession:      _pi(j['id_session']),
        encryption:     _ps(j['encryption']),
        idSessionLabel: _ps(j['id_session_label']),
        storeName:      _ps(j['store_name']),
        openedBy:       _ps(j['opened_by']),
        openingTime:    j['opening_time']?.toString(),
        closingTime:    j['closing_time']?.toString(),
        openingBalance: _pd(j['opening_balance']),
        closingBalance: _pdn(j['closing_balance']),
        totalSales:     _pd(j['total_sales']),
        status:         _ps(j['status']),
      );

  bool get isOpen => status.toUpperCase() == 'OPEN';
}

class StoreSessionDetail {
  final int idSession;
  final String encryption;
  final String idSessionLabel;
  final String storeName;
  final String cashierName;
  final String status;
  final String? openingTime;
  final String? closingTime;
  final double openingBalance;
  final double? closingBalance;
  final double totalSales;
  final int totalOrders;
  final double cashSalesAmount;
  final double nonCashSalesAmount;
  final double totalCashIn;
  final double totalCashOut;

  StoreSessionDetail({
    required this.idSession,
    required this.encryption,
    required this.idSessionLabel,
    required this.storeName,
    required this.cashierName,
    required this.status,
    this.openingTime,
    this.closingTime,
    required this.openingBalance,
    this.closingBalance,
    required this.totalSales,
    required this.totalOrders,
    required this.cashSalesAmount,
    required this.nonCashSalesAmount,
    required this.totalCashIn,
    required this.totalCashOut,
  });

  factory StoreSessionDetail.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] ?? json) as Map<String, dynamic>;
    return StoreSessionDetail(
      idSession:          _pi(d['id_session']),
      encryption:         _ps(d['encryption']),
      idSessionLabel:     _ps(d['id_session_label']),
      storeName:          _ps(d['store']?['store_name']),
      cashierName:        _ps(d['cashier']?['nama_lengkap']),
      status:             _ps(d['status']),
      openingTime:        d['opening_time']?.toString(),
      closingTime:        d['closing_time']?.toString(),
      openingBalance:     _pd(d['opening_balance']),
      closingBalance:     _pdn(d['closing_balance']),
      totalSales:         _pd(d['total_sales']),
      totalOrders:        _pi(d['total_orders']),
      cashSalesAmount:    _pd(d['cash_sales_amount']),
      nonCashSalesAmount: _pd(d['non_cash_sales_amount']),
      totalCashIn:        _pd(d['total_cash_in']),
      totalCashOut:       _pd(d['total_cash_out']),
    );
  }

  bool get isOpen => status.toUpperCase() == 'OPEN';
}

class StoreSessionTransaction {
  final int idTransaction;
  final String encryption;
  final String? transactionDate;
  final String transactionCode;
  final String paymentMethod;
  final double totalAmount;
  final double paidAmount;
  final double changeAmount;
  final String status;
  final String cashier;
  final String customer;
  final String store;

  StoreSessionTransaction({
    required this.idTransaction,
    required this.encryption,
    this.transactionDate,
    required this.transactionCode,
    required this.paymentMethod,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.status,
    required this.cashier,
    required this.customer,
    required this.store,
  });

  factory StoreSessionTransaction.fromJson(Map<String, dynamic> j) => StoreSessionTransaction(
        idTransaction:   _pi(j['id_transaction']),
        encryption:      _ps(j['encryption']),
        transactionDate: j['transaction_date']?.toString(),
        transactionCode: _ps(j['transaction_code']),
        paymentMethod:   _ps(j['payment_method']),
        totalAmount:     _pd(j['total_amount']),
        paidAmount:      _pd(j['paid_amount']),
        changeAmount:    _pd(j['change_amount']),
        status:          _ps(j['status']),
        cashier:         _ps(j['cashier']),
        customer:        _ps(j['customer']),
        store:           _ps(j['store']),
      );
}

class StoreSessionCashMovement {
  final int idMovement;
  final String movementType;
  final double amount;
  final String? notes;
  final String? createdAt;

  StoreSessionCashMovement({
    required this.idMovement,
    required this.movementType,
    required this.amount,
    this.notes,
    this.createdAt,
  });

  factory StoreSessionCashMovement.fromJson(Map<String, dynamic> j) => StoreSessionCashMovement(
        idMovement:   _pi(j['id_movement']),
        movementType: _ps(j['movement_type']),
        amount:       _pd(j['amount']),
        notes:        j['notes']?.toString(),
        createdAt:    j['created_at']?.toString(),
      );

  bool get isIn => movementType.toUpperCase() == 'IN';
}

class StoreSessionCashSummary {
  final double totalIn, totalOut, totalAll;

  StoreSessionCashSummary({
    required this.totalIn,
    required this.totalOut,
    required this.totalAll,
  });

  factory StoreSessionCashSummary.fromJson(Map<String, dynamic> j) => StoreSessionCashSummary(
        totalIn:  _pd(j['total_in']),
        totalOut: _pd(j['total_out']),
        totalAll: _pd(j['total_all']),
      );
}

class StoreSessionTransactionItem {
  final String productCode;
  final String productName;
  final double qty;
  final double price;
  final double subtotal;

  StoreSessionTransactionItem({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory StoreSessionTransactionItem.fromJson(Map<String, dynamic> j) {
    final name = _ps(j['product']?['product_name']);
    return StoreSessionTransactionItem(
      productCode: _ps(j['product']?['product_code']),
      productName: name.isEmpty ? '-' : name,
      qty:         _pd(j['qty']),
      price:       _pd(j['price'] ?? j['unit_price']),
      subtotal:    _pd(j['subtotal']),
    );
  }
}

class StoreSessionTransactionDetail {
  final int idTransaction;
  final String encryption;
  final String transactionCode;
  final String? transactionDate;
  final String paymentMethod;
  final String status;
  final double totalAmount;
  final double paidAmount;
  final double changeAmount;
  final String customerName;
  final String cashierName;
  final String storeName;
  final String sessionLabel;
  final List<StoreSessionTransactionItem> items;

  StoreSessionTransactionDetail({
    required this.idTransaction,
    required this.encryption,
    required this.transactionCode,
    this.transactionDate,
    required this.paymentMethod,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.customerName,
    required this.cashierName,
    required this.storeName,
    required this.sessionLabel,
    required this.items,
  });

  factory StoreSessionTransactionDetail.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] ?? json) as Map<String, dynamic>;
    final store = _ps(d['store']?['store_name']);
    final idSession = _pi(d['session']?['id_session'] ?? d['id_session']);

    return StoreSessionTransactionDetail(
      idTransaction:   _pi(d['id_transaction']),
      encryption:      _ps(d['encryption']),
      transactionCode: _ps(d['transaction_code']),
      transactionDate: d['transaction_date']?.toString(),
      paymentMethod:   _ps(d['payment_method']),
      status:          _ps(d['status']),
      totalAmount:     _pd(d['total_amount']),
      paidAmount:      _pd(d['paid_amount']),
      changeAmount:    _pd(d['change_amount']),
      customerName:    _ps(d['customer']?['customer_name']),
      cashierName:     _ps(d['cashier']?['nama_lengkap']),
      storeName:       store,
      sessionLabel:    '${store.isEmpty ? 'N/A' : store}/${idSession.toString().padLeft(6, '0')}',
      items: (d['details'] as List? ?? [])
          .map((e) => StoreSessionTransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SessionStoreOption {
  final int idStore;
  final String? encryption;
  final String storeName;

  SessionStoreOption({required this.idStore, this.encryption, required this.storeName});

  factory SessionStoreOption.fromJson(Map<String, dynamic> j) => SessionStoreOption(
        idStore:    _pi(j['id_store']),
        encryption: j['encryption']?.toString(),
        storeName:  _ps(j['store_name']),
      );

  @override bool operator ==(Object o) => o is SessionStoreOption && o.idStore == idStore;
  @override int get hashCode => idStore.hashCode;
}

class StoreSessionFormOptions {
  final List<SessionStoreOption> storeList;
  final List<String> paymentMethodList;
  final List<String> statusList;

  StoreSessionFormOptions({
    required this.storeList,
    required this.paymentMethodList,
    required this.statusList,
  });

  factory StoreSessionFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StoreSessionFormOptions(
      storeList: (data['store_list'] as List? ?? [])
          .map((e) => SessionStoreOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethodList: (data['payment_method_list'] as List? ?? []).map((e) => e.toString()).toList(),
      statusList:        (data['status_list'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class SessionExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  SessionExportUrlInfo({required this.url, required this.headers});
}