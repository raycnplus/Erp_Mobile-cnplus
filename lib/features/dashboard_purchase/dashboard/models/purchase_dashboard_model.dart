// features/dashboard_purchase/models/purchase_dashboard_model.dart


// Helper function to safely parse string to double
double safeParseDouble(dynamic value) {
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  } else if (value is num) {
    return value.toDouble();
  }
  return 0.0;
}

// Main response model
class PurchaseDashboardResponse {
  final Summary summary;
  final Charts charts;
  final List<TopProduct> topProducts;
  final List<TopVendor> topVendors;
  final List<TopPurchaseOrder> topPurchaseOrders;
  final List<TopCategory> topCategories;

  PurchaseDashboardResponse({
    required this.summary,
    required this.charts,
    required this.topProducts,
    required this.topVendors,
    required this.topPurchaseOrders,
    required this.topCategories,
  });

  factory PurchaseDashboardResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseDashboardResponse(
      summary: Summary.fromJson(json['summary'] ?? {}),
      charts: Charts.fromJson(json['charts'] ?? {}),
      topProducts: (json['top_products'] as List<dynamic>? ?? [])
          .map((item) => TopProduct.fromJson(item))
          .toList(),
      topVendors: (json['top_vendors'] as List<dynamic>? ?? [])
          .map((item) => TopVendor.fromJson(item))
          .toList(),
      topPurchaseOrders: (json['top_purchase_orders'] as List<dynamic>? ?? [])
          .map((item) => TopPurchaseOrder.fromJson(item))
          .toList(),
      topCategories: (json['top_categories'] as List<dynamic>? ?? [])
          .map((item) => TopCategory.fromJson(item))
          .toList(),
    );
  }
}

// Summary model for StatCards
class Summary {
  final int purchaseRequest;
  final int rfq;
  final int purchaseOrder;
  final int directPurchase;

  Summary({
    required this.purchaseRequest,
    required this.rfq,
    required this.purchaseOrder,
    required this.directPurchase,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      purchaseRequest: json['purchase_request'] ?? 0,
      rfq: json['rfq'] ?? 0,
      purchaseOrder: json['purchase_order'] ?? 0,
      directPurchase: json['direct_purchase'] ?? 0,
    );
  }
}

// Charts model for analysis chart
class Charts {
  final SpendingByMonth spendingByMonth;

  Charts({required this.spendingByMonth});

  factory Charts.fromJson(Map<String, dynamic> json) {
    return Charts(
      spendingByMonth:
          SpendingByMonth.fromJson(json['spending_by_month'] ?? {}),
    );
  }
}

class SpendingByMonth {
  final List<String> labels;
  final List<double> data;

  SpendingByMonth({required this.labels, required this.data});

  factory SpendingByMonth.fromJson(Map<String, dynamic> json) {
    return SpendingByMonth(
      labels: List<String>.from(json['labels'] ?? []),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => safeParseDouble(item))
          .toList(),
    );
  }
}

// Top lists models
class TopProduct {
  final String productName;
  final double totalSpent;

  TopProduct({required this.productName, required this.totalSpent});

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productName: json['product_name'] ?? 'Unknown',
      totalSpent: safeParseDouble(json['total_spent']),
    );
  }
}

class TopVendor {
  final String vendorName;
  final double totalSpent;

  TopVendor({required this.vendorName, required this.totalSpent});

  factory TopVendor.fromJson(Map<String, dynamic> json) {
    return TopVendor(
      vendorName: json['vendor_name'] ?? 'Unknown',
      totalSpent: safeParseDouble(json['total_spent']),
    );
  }
}

class TopPurchaseOrder {
  final String reference;
  final double totalAmount;

  TopPurchaseOrder({required this.reference, required this.totalAmount});

  factory TopPurchaseOrder.fromJson(Map<String, dynamic> json) {
    return TopPurchaseOrder(
      reference: json['reference'] ?? 'Unknown',
      totalAmount: safeParseDouble(json['total_amount']),
    );
  }
}

class TopCategory {
  final String productCategoryName;
  final double totalAmount;

  TopCategory({required this.productCategoryName, required this.totalAmount});

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return TopCategory(
      productCategoryName: json['product_category_name'] ?? 'Unknown',
      totalAmount: safeParseDouble(json['total_amount']),
    );
  }
}