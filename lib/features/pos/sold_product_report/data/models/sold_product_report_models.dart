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

class SoldProductReportItem {
  final String productCode;
  final String productName;
  final String store;
  final double totalQty;
  final double totalAmount;

  SoldProductReportItem({
    required this.productCode,
    required this.productName,
    required this.store,
    required this.totalQty,
    required this.totalAmount,
  });

  factory SoldProductReportItem.fromJson(Map<String, dynamic> j) => SoldProductReportItem(
        productCode: _ps(j['product_code']),
        productName: _ps(j['product_name']),
        store:       _ps(j['store']),
        totalQty:    _pd(j['total_qty']),
        totalAmount: _pd(j['total_amount']),
      );
}

class SoldProductReportPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  SoldProductReportPaginationMeta({
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

class SoldProductReportFormOptions {
  final List<StoreOption> storeList;

  SoldProductReportFormOptions({required this.storeList});

  factory SoldProductReportFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SoldProductReportFormOptions(
      storeList: (data['store_list'] as List? ?? [])
          .map((e) => StoreOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}