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

class PosSummary {
  final int totalTransactions;
  final double totalSales;
  final double yesterdaySales;
  final double comparisonPct;
  final double salesThisWeek;
  final double salesThisMonth;

  PosSummary({
    required this.totalTransactions,
    required this.totalSales,
    required this.yesterdaySales,
    required this.comparisonPct,
    required this.salesThisWeek,
    required this.salesThisMonth,
  });

  factory PosSummary.fromJson(Map<String, dynamic> json) {
    return PosSummary(
      totalTransactions: _pi(json['total_transactions']),
      totalSales: _pd(json['total_sales']),
      yesterdaySales: _pd(json['yesterday_sales']),
      comparisonPct: _pd(json['comparison_pct']),
      salesThisWeek: _pd(json['sales_this_week']),
      salesThisMonth: _pd(json['sales_this_month']),
    );
  }
}

class PosTopProduct {
  final String productName;
  final double totalQty;
  final double totalAmount;

  PosTopProduct({
    required this.productName,
    required this.totalQty,
    required this.totalAmount,
  });

  factory PosTopProduct.fromJson(Map<String, dynamic> json) {
    return PosTopProduct(
      productName: json['product_name']?.toString() ?? '',
      totalQty: _pd(json['total_qty']),
      totalAmount: _pd(json['total_amount']),
    );
  }
}

class PosPaymentMethod {
  final String paymentMethod;
  final int total;
  final double totalAmount;

  PosPaymentMethod({
    required this.paymentMethod,
    required this.total,
    required this.totalAmount,
  });

  factory PosPaymentMethod.fromJson(Map<String, dynamic> json) {
    return PosPaymentMethod(
      paymentMethod: json['payment_method']?.toString() ?? '-',
      total: _pi(json['total']),
      totalAmount: _pd(json['total_amount']),
    );
  }
}

class PosFilterInfo {
  final String startDate;
  final String endDate;

  PosFilterInfo({
    required this.startDate,
    required this.endDate,
  });

  factory PosFilterInfo.fromJson(Map<String, dynamic> json) {
    return PosFilterInfo(
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
    );
  }
}

class PosDashboardResponse {
  final PosFilterInfo filters;
  final PosSummary summary;
  final List<PosTopProduct> topProducts;
  final List<PosPaymentMethod> paymentMethods;

  PosDashboardResponse({
    required this.filters,
    required this.summary,
    required this.topProducts,
    required this.paymentMethods,
  });

  factory PosDashboardResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return PosDashboardResponse(
      filters: PosFilterInfo.fromJson(data['filters'] ?? {}),
      summary: PosSummary.fromJson(data['summary'] ?? {}),
      topProducts: (data['top_products'] as List? ?? [])
          .map((e) => PosTopProduct.fromJson(e))
          .toList(),
      paymentMethods: (data['payment_methods'] as List? ?? [])
          .map((e) => PosPaymentMethod.fromJson(e))
          .toList(),
    );
  }
}