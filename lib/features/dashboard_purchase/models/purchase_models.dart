class DashboardData {
  final List<MonthlyPurchaseData> purchaseAnalysis;
  final List<TopListData> topCategoryProduct;
  final List<TopListData> topPurchaseOrder;

  DashboardData({
    required this.purchaseAnalysis,
    required this.topCategoryProduct,
    required this.topPurchaseOrder,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    var purchaseList = json['purchase_analysis'] as List? ?? [];
    List<MonthlyPurchaseData> purchaseData = purchaseList
        .map((item) => MonthlyPurchaseData.fromJson(item))
        .toList();

    var categoryList = json['top_category_product'] as List? ?? [];
    List<TopListData> categoryData = categoryList
        .map((item) => TopListData.fromJson(item))
        .toList();

    var poList = json['top_purchase_order'] as List? ?? [];
    List<TopListData> poData = poList
        .map((item) => TopListData.fromJson(item))
        .toList();

    return DashboardData(
      purchaseAnalysis: purchaseData,
      topCategoryProduct: categoryData,
      topPurchaseOrder: poData,
    );
  }
}

class MonthlyPurchaseData {
  final int month;
  final double amount;

  MonthlyPurchaseData({required this.month, required this.amount});

  factory MonthlyPurchaseData.fromJson(Map<String, dynamic> json) {
    return MonthlyPurchaseData(
      month: json['month'] ?? 0,
      amount: (json['amount'] as num? ?? 0).toDouble(),
    );
  }
}

class TopListData {
  final String title;
  final String value;

  TopListData({required this.title, required this.value});

  factory TopListData.fromJson(Map<String, dynamic> json) {
    return TopListData(title: json['title'] ?? '', value: json['value'] ?? '');
  }
}
