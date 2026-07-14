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

class SalesSummary {
  final double revenue;
  final double aov;
  final int orders;

  SalesSummary({
    required this.revenue,
    required this.aov,
    required this.orders,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> j) =>
      SalesSummary(
        revenue: _pd(j['revenue']),
        aov: _pd(j['aov']),
        orders: _pi(j['orders']),
      );
}

class RevenueTrend {
  final List<String> labels;
  final List<double> values;

  RevenueTrend({
    required this.labels,
    required this.values,
  });

  factory RevenueTrend.fromJson(Map<String, dynamic> j) =>
      RevenueTrend(
        labels: List<String>.from(j['labels'] ?? []),
        values: (j['values'] as List? ?? [])
            .map((v) => _pd(v))
            .toList(),
      );
}

class TopProduct {
  final String productName;
  final double revenue;

  TopProduct({
    required this.productName,
    required this.revenue,
  });

  factory TopProduct.fromJson(Map<String, dynamic> j) =>
      TopProduct(
        productName: j['product_name']?.toString() ?? '',
        revenue: _pd(j['revenue']),
      );
}

class RecentOrder {
  final String reference;
  final String customerName;
  final String status;
  final double untaxedAmount;

  RecentOrder({
    required this.reference,
    required this.customerName,
    required this.status,
    required this.untaxedAmount,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> j) =>
      RecentOrder(
        reference: j['reference']?.toString() ?? '',
        customerName: j['customer_name']?.toString() ?? '',
        status: j['status']?.toString() ?? '',
        untaxedAmount: _pd(j['untaxed_amount']),
      );
}

class SalesData {
  final SalesSummary summary;
  final RevenueTrend revenueTrend;
  final List<TopProduct> topProducts;
  final List<RecentOrder> recentOrders;

  SalesData({
    required this.summary,
    required this.revenueTrend,
    required this.topProducts,
    required this.recentOrders,
  });

  factory SalesData.fromJson(Map<String, dynamic> j) =>
      SalesData(
        summary: SalesSummary.fromJson(j['summary'] ?? {}),
        revenueTrend: RevenueTrend.fromJson(
          j['revenue_trend'] ?? {},
        ),
        topProducts: (j['top_products'] as List? ?? [])
            .map((e) => TopProduct.fromJson(e))
            .toList(),
        recentOrders: (j['recent_orders'] as List? ?? [])
            .map((e) => RecentOrder.fromJson(e))
            .toList(),
      );
}

class InventorySummary {
  final double stockValue;
  final double cogs;
  final int lowStockCount;
  final double turnoverRatio;

  InventorySummary({
    required this.stockValue,
    required this.cogs,
    required this.lowStockCount,
    required this.turnoverRatio,
  });

  factory InventorySummary.fromJson(
    Map<String, dynamic> j,
  ) =>
      InventorySummary(
        stockValue: _pd(j['stock_value']),
        cogs: _pd(j['cogs']),
        lowStockCount: _pi(j['low_stock_count']),
        turnoverRatio: _pd(j['turnover_ratio']),
      );
}

class MovementTrend {
  final List<String> labels;
  final List<double> qtyIn;
  final List<double> qtyOut;

  MovementTrend({
    required this.labels,
    required this.qtyIn,
    required this.qtyOut,
  });

  factory MovementTrend.fromJson(Map<String, dynamic> j) =>
      MovementTrend(
        labels: List<String>.from(j['labels'] ?? []),
        qtyIn: (j['qty_in'] as List? ?? [])
            .map((v) => _pd(v))
            .toList(),
        qtyOut: (j['qty_out'] as List? ?? [])
            .map((v) => _pd(v))
            .toList(),
      );
}

class InventoryData {
  final InventorySummary summary;
  final MovementTrend movementTrend;

  InventoryData({
    required this.summary,
    required this.movementTrend,
  });

  factory InventoryData.fromJson(Map<String, dynamic> j) =>
      InventoryData(
        summary: InventorySummary.fromJson(
          j['summary'] ?? {},
        ),
        movementTrend: MovementTrend.fromJson(
          j['movement_trend'] ?? {},
        ),
      );
}

class PurchaseSummary {
  final double vendorSpend;
  final int poCycleTimeDays;

  PurchaseSummary({
    required this.vendorSpend,
    required this.poCycleTimeDays,
  });

  factory PurchaseSummary.fromJson(
    Map<String, dynamic> j,
  ) =>
      PurchaseSummary(
        vendorSpend: _pd(j['vendor_spend']),
        poCycleTimeDays: _pi(
          j['po_cycle_time_days'],
        ),
      );
}

class TopVendors {
  final List<String> labels;
  final List<double> values;

  TopVendors({
    required this.labels,
    required this.values,
  });

  factory TopVendors.fromJson(Map<String, dynamic> j) =>
      TopVendors(
        labels: List<String>.from(j['labels'] ?? []),
        values: (j['values'] as List? ?? [])
            .map((v) => _pd(v))
            .toList(),
      );
}

class PurchaseData {
  final PurchaseSummary summary;
  final TopVendors topVendors;

  PurchaseData({
    required this.summary,
    required this.topVendors,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> j) =>
      PurchaseData(
        summary: PurchaseSummary.fromJson(
          j['summary'] ?? {},
        ),
        topVendors: TopVendors.fromJson(
          j['top_vendors'] ?? {},
        ),
      );
}

class GeneralDashboardModel {
  final String startDate;
  final String endDate;
  final SalesData sales;
  final InventoryData inventory;
  final PurchaseData purchase;

  GeneralDashboardModel({
    required this.startDate,
    required this.endDate,
    required this.sales,
    required this.inventory,
    required this.purchase,
  });

  factory GeneralDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final filters = json['filters'] ?? {};
    final data = json['data'] ?? {};

    return GeneralDashboardModel(
      startDate:
          filters['start_date']?.toString() ?? '',
      endDate:
          filters['end_date']?.toString() ?? '',
      sales: SalesData.fromJson(
        data['sales'] ?? {},
      ),
      inventory: InventoryData.fromJson(
        data['inventory'] ?? {},
      ),
      purchase: PurchaseData.fromJson(
        data['purchase'] ?? {},
      ),
    );
  }
}