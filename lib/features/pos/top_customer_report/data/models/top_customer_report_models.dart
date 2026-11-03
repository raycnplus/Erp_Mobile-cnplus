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

class TopCustomerReportItem {
  final String customer;
  final String store;
  final int totalTransaction;
  final double totalAmount;

  TopCustomerReportItem({
    required this.customer,
    required this.store,
    required this.totalTransaction,
    required this.totalAmount,
  });

  factory TopCustomerReportItem.fromJson(Map<String, dynamic> j) => TopCustomerReportItem(
        customer:         _ps(j['customer']),
        store:            _ps(j['store']),
        totalTransaction: _pi(j['total_transaction']),
        totalAmount:      _pd(j['total_amount']),
      );
}

class TopCustomerReportPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  TopCustomerReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class StoreOption {
  final int idStore;
  final String? encryption;
  final String storeName;

  StoreOption({required this.idStore, this.encryption, required this.storeName});

  factory StoreOption.fromJson(Map<String, dynamic> j) => StoreOption(
        idStore:    _pi(j['id_store']),
        encryption: j['encryption']?.toString(),
        storeName:  _ps(j['store_name']),
      );

  @override bool operator ==(Object o) => o is StoreOption && o.idStore == idStore;
  @override int get hashCode => idStore.hashCode;
}

class TopCustomerReportFormOptions {
  final List<StoreOption> storeList;

  TopCustomerReportFormOptions({required this.storeList});

  factory TopCustomerReportFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TopCustomerReportFormOptions(
      storeList: (data['store_list'] as List? ?? [])
          .map((e) => StoreOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
