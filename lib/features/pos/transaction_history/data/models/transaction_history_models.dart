double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class TransactionHistoryPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  TransactionHistoryPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory TransactionHistoryPaginationMeta.fromJson(Map<String, dynamic> j) =>
      TransactionHistoryPaginationMeta(
        currentPage: _pi(j['current_page']) == 0 ? 1 : _pi(j['current_page']),
        lastPage:    _pi(j['last_page']) == 0 ? 1 : _pi(j['last_page']),
        perPage:     _pi(j['per_page']),
        total:       _pi(j['total']),
      );
}

class TransactionHistoryItem {
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

  TransactionHistoryItem({
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

  factory TransactionHistoryItem.fromJson(Map<String, dynamic> j) => TransactionHistoryItem(
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

class TransactionHistoryDetailItem {
  final String productCode;
  final String productName;
  final double qty;
  final double price;
  final double subtotal;

  TransactionHistoryDetailItem({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory TransactionHistoryDetailItem.fromJson(Map<String, dynamic> j) {
    final name = _ps(j['product']?['product_name']);
    return TransactionHistoryDetailItem(
      productCode: _ps(j['product']?['product_code']),
      productName: name.isEmpty ? '-' : name,
      qty:         _pd(j['qty']),
      price:       _pd(j['price'] ?? j['unit_price']),
      subtotal:    _pd(j['subtotal']),
    );
  }
}

class TransactionHistoryDetail {
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
  final List<TransactionHistoryDetailItem> items;

  TransactionHistoryDetail({
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
    required this.items,
  });

  factory TransactionHistoryDetail.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] ?? json) as Map<String, dynamic>;
    return TransactionHistoryDetail(
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
      storeName:       _ps(d['store']?['store_name']),
      items: (d['details'] as List? ?? [])
          .map((e) => TransactionHistoryDetailItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HistoryStoreOption {
  final int idStore;
  final String? encryption;
  final String storeName;

  HistoryStoreOption({required this.idStore, this.encryption, required this.storeName});

  factory HistoryStoreOption.fromJson(Map<String, dynamic> j) => HistoryStoreOption(
        idStore:    _pi(j['id_store']),
        encryption: j['encryption']?.toString(),
        storeName:  _ps(j['store_name']),
      );

  @override bool operator ==(Object o) => o is HistoryStoreOption && o.idStore == idStore;
  @override int get hashCode => idStore.hashCode;
}

class TransactionHistoryFormOptions {
  final List<HistoryStoreOption> storeList;
  final List<String> paymentMethodList;
  final List<String> statusList;
  
  TransactionHistoryFormOptions({
    required this.storeList,
    required this.paymentMethodList,
    required this.statusList,
  });

  factory TransactionHistoryFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TransactionHistoryFormOptions(
      storeList: (data['store_list'] as List? ?? [])
          .map((e) => HistoryStoreOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethodList: (data['payment_method_list'] as List? ?? []).map((e) => e.toString()).toList(),
      statusList:        (data['status_list'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class HistoryExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  HistoryExportUrlInfo({required this.url, required this.headers});
}