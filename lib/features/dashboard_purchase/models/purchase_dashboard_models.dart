class PurchaseSummary {
  final int totalPurchase;
  final int totalInvoices;

  PurchaseSummary({
    required this.totalPurchase,
    required this.totalInvoices,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      totalPurchase: json['total_purchase'] ?? 0,
      totalInvoices: json['total_invoices'] ?? 0,
    );
  }
}

class MonthlyInvoice {
  final String month;
  final double amount;

  MonthlyInvoice({
    required this.month,
    required this.amount,
  });

  factory MonthlyInvoice.fromJson(Map<String, dynamic> json) {
    return MonthlyInvoice(
      month: json['month'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class TopProduct {
  final String name;
  final int quantity;

  TopProduct({
    required this.name,
    required this.quantity,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}

class TopCategory {
  final String category;
  final int count;

  TopCategory({
    required this.category,
    required this.count,
  });

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return TopCategory(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class RecentPurchase {
  final String item;
  final String date;
  final int amount;

  RecentPurchase({
    required this.item,
    required this.date,
    required this.amount,
  });

  factory RecentPurchase.fromJson(Map<String, dynamic> json) {
    return RecentPurchase(
      item: json['item'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }
}

class DashboardData {
  final PurchaseSummary summary;
  final List<MonthlyInvoice> invoices;
  final List<TopProduct> products;
  final List<TopCategory> categories;
  final List<RecentPurchase> recentPurchases;

  DashboardData({
    required this.summary,
    required this.invoices,
    required this.products,
    required this.categories,
    required this.recentPurchases,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      summary: PurchaseSummary.fromJson(json['summary']),
      invoices: (json['monthly_invoice'] as List)
          .map((e) => MonthlyInvoice.fromJson(e))
          .toList(),
      products: (json['top_products'] as List)
          .map((e) => TopProduct.fromJson(e))
          .toList(),
      categories: (json['top_categories'] as List)
          .map((e) => TopCategory.fromJson(e))
          .toList(),
      recentPurchases: (json['recent_purchases'] as List)
          .map((e) => RecentPurchase.fromJson(e))
          .toList(),
    );
  }
}