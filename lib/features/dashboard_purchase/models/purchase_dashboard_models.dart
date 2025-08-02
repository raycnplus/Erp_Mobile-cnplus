// Purchase Summary
class PurchaseSummary {
  final int totalPurchases;
  final double totalAmount;

  PurchaseSummary({
    required this.totalPurchases,
    required this.totalAmount,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      totalPurchases: json['total_purchases'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}

// Monthly Invoice
class MonthlyInvoice {
  final int month;
  final int year;
  final double amount;

  MonthlyInvoice({required this.month, required this.year, required this.amount});
}


// class MonthlyInvoice {
//   final String month;
//   final double amount;
//
//   MonthlyInvoice({
//     required this.month,
//     required this.amount,
//   });
//
//   factory MonthlyInvoice.fromJson(Map<String, dynamic> json) {
//     return MonthlyInvoice(
//       month: json['month'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//     );
//   }
// }

// Top Product
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

// Top Category
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

// Dashboard Data Wrapper
class DashboardData {
  final PurchaseSummary summary;
  final List<MonthlyInvoice> invoices;
  final List<TopProduct> products;
  final List<TopCategory> categories;

  DashboardData({
    required this.summary,
    required this.invoices,
    required this.products,
    required this.categories,
  });
}