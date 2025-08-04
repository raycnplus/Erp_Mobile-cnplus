class DashboardData {
  final List<MonthlyPurchaseData> purchaseAnalysis;
  final List<TopListData> topCategoryProduct;
  final List<TopListData> topPurchaseOrder;

  DashboardData({
    required this.purchaseAnalysis,
    required this.topCategoryProduct,
    required this.topPurchaseOrder,
  });

  /// Mengubah JSON Map dari API menjadi objek DashboardData.
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    // Parsing list untuk purchase analysis, dengan pengecekan null
    var purchaseList = json['purchase_analysis'] as List? ?? [];
    List<MonthlyPurchaseData> purchaseData =
    purchaseList.map((item) => MonthlyPurchaseData.fromJson(item)).toList();

    // Parsing list untuk top category product
    var categoryList = json['top_category_product'] as List? ?? [];
    List<TopListData> categoryData =
    categoryList.map((item) => TopListData.fromJson(item)).toList();

    // Parsing list untuk top purchase order
    var poList = json['top_purchase_order'] as List? ?? [];
    List<TopListData> poData =
    poList.map((item) => TopListData.fromJson(item)).toList();

    return DashboardData(
      purchaseAnalysis: purchaseData,
      topCategoryProduct: categoryData,
      topPurchaseOrder: poData,
    );
  }
}

// --- Sub-Model untuk Grafik Line Chart ---
class MonthlyPurchaseData {
  final int month;
  final double amount;

  MonthlyPurchaseData({
    required this.month,
    required this.amount,
  });

  factory MonthlyPurchaseData.fromJson(Map<String, dynamic> json) {
    return MonthlyPurchaseData(
      month: json['month'] ?? 0,
      // Menggunakan 'as num' agar aman untuk integer maupun double dari JSON
      amount: (json['amount'] as num? ?? 0).toDouble(),
    );
  }
}

// --- Sub-Model untuk Daftar Top 5 ---
class TopListData {
  final String title;
  final String value;

  TopListData({
    required this.title,
    required this.value,
  });

  factory TopListData.fromJson(Map<String, dynamic> json) {
    return TopListData(
      title: json['title'] ?? '',
      value: json['value'] ?? '',
    );
  }
}