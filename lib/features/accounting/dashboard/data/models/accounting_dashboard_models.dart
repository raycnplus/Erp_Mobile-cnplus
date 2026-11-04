import 'package:flutter/material.dart';

int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

double _parseDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

List<double> _parseDoubleList(dynamic v) =>
    (v as List? ?? []).map((e) => _parseDouble(e)).toList();

class AccountingChartData {
  final String label;
  final double value;
  final Color? color;

  AccountingChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class TopListData {
  final String title;
  final String value;
  final double amount;

  TopListData({required this.title, required this.value, required this.amount});

  factory TopListData.fromJson(Map<String, dynamic> json) {
    final rawValue = json['total_amount'] ?? json['value'];
    return TopListData(
      title: json['reference']?.toString() ?? json['title']?.toString() ?? '',
      value: rawValue?.toString() ?? '',
      amount: _parseDouble(rawValue),
    );
  }
}

class SalesBreakdownData {
  final String name;
  final double totalSales;

  SalesBreakdownData({required this.name, required this.totalSales});

  factory SalesBreakdownData.fromJson(Map<String, dynamic> json) => SalesBreakdownData(
    name: json['customer_category_name']?.toString() ??
        json['customer_name']?.toString() ??
        '',
    totalSales: _parseDouble(json['total_sales']),
  );
}

class AgingData {
  final String customerName;
  final double bln1_6;
  final double bln6_12;
  final double bln12_24;
  final double bln24Plus;

  AgingData({
    required this.customerName,
    required this.bln1_6,
    required this.bln6_12,
    required this.bln12_24,
    required this.bln24Plus,
  });

  factory AgingData.fromJson(Map<String, dynamic> json) => AgingData(
    customerName: json['customer_name']?.toString() ?? json['vendor_name']?.toString() ?? '',
    bln1_6:    _parseDouble(json['bln_1_6']),
    bln6_12:   _parseDouble(json['bln_6_12']),
    bln12_24:  _parseDouble(json['bln_12_24']),
    bln24Plus: _parseDouble(json['bln_24_plus']),
  );

  double get total => bln1_6 + bln6_12 + bln12_24 + bln24Plus;
}

class RevenueExpenseData {
  final String date;
  final double total;

  RevenueExpenseData({required this.date, required this.total});

  factory RevenueExpenseData.fromJson(Map<String, dynamic> json) => RevenueExpenseData(
    date: json['date']?.toString() ?? '',
    total: _parseDouble(json['total']),
  );
}

class FinancialPerformanceData {
  final List<String> labels;
  final List<double> revenue;
  final List<double> expense;
  final List<double> receivable;
  final List<double> profit;

  FinancialPerformanceData({
    required this.labels,
    required this.revenue,
    required this.expense,
    required this.receivable,
    required this.profit,
  });

  factory FinancialPerformanceData.fromJson(Map<String, dynamic> json) =>
      FinancialPerformanceData(
        labels: (json['labels'] as List? ?? []).map((e) => e.toString()).toList(),
        revenue: _parseDoubleList(json['revenue']),
        expense: _parseDoubleList(json['expense']),
        receivable: _parseDoubleList(json['receivable']),
        profit: _parseDoubleList(json['profit']),
      );
}

class AccountingSummary {
  final double totalInvoice;
  final double totalInvoiceProduct;
  final double totalInvoiceService;
  final double totalSalesOrder;
  final double totalSalesOrderProduct;
  final double totalSalesOrderService;
  final double totalBill;
  final double totalPurchaseOrder;

  AccountingSummary({
    required this.totalInvoice,
    required this.totalInvoiceProduct,
    required this.totalInvoiceService,
    required this.totalSalesOrder,
    required this.totalSalesOrderProduct,
    required this.totalSalesOrderService,
    required this.totalBill,
    required this.totalPurchaseOrder,
  });

  factory AccountingSummary.fromJson(Map<String, dynamic> json) => AccountingSummary(
    totalInvoice: _parseDouble(json['total_invoice']),
    totalInvoiceProduct: _parseDouble(json['total_invoice_product']),
    totalInvoiceService: _parseDouble(json['total_invoice_service']),
    totalSalesOrder: _parseDouble(json['total_sales_order']),
    totalSalesOrderProduct: _parseDouble(json['total_sales_order_product']),
    totalSalesOrderService: _parseDouble(json['total_sales_order_service']),
    totalBill: _parseDouble(json['total_bill']),
    totalPurchaseOrder: _parseDouble(json['total_purchase_order']),
  );
}

class AccountingCharts {
  final List<RevenueExpenseData> revenue;
  final List<RevenueExpenseData> expense;
  final FinancialPerformanceData financialPerformance;

  AccountingCharts({
    required this.revenue,
    required this.expense,
    required this.financialPerformance,
  });

  factory AccountingCharts.fromJson(Map<String, dynamic> json) => AccountingCharts(
    revenue: (json['revenue'] as List? ?? [])
        .map((e) => RevenueExpenseData.fromJson(e as Map<String, dynamic>))
        .toList(),
    expense: (json['expense'] as List? ?? [])
        .map((e) => RevenueExpenseData.fromJson(e as Map<String, dynamic>))
        .toList(),
    financialPerformance: FinancialPerformanceData.fromJson(
      (json['financial_performance'] as Map?)?.cast<String, dynamic>() ?? {},
    ),
  );
}

class KpiMetric {
  final double realisasi;
  final double plan;
  final double achievement;

  const KpiMetric({this.realisasi = 0, this.plan = 0, this.achievement = 0});

  factory KpiMetric.fromJson(dynamic json) {
    final m = json is Map ? json : const {};
    return KpiMetric(
      realisasi: _parseDouble(m['realisasi']),
      plan: _parseDouble(m['plan']),
      achievement: _parseDouble(m['achievement']),
    );
  }
}

class KpiPeriods {
  final KpiMetric thisMonth;
  final KpiMetric ytd;
  final KpiMetric fullPeriod;

  const KpiPeriods({
    this.thisMonth = const KpiMetric(),
    this.ytd = const KpiMetric(),
    this.fullPeriod = const KpiMetric(),
  });

  factory KpiPeriods.fromJson(dynamic json) {
    final m = json is Map ? json : const {};
    return KpiPeriods(
      thisMonth: KpiMetric.fromJson(m['this_month']),
      ytd: KpiMetric.fromJson(m['ytd']),
      fullPeriod: KpiMetric.fromJson(m['full_period']),
    );
  }
}

class KpiData {
  final String labelThisMonth;
  final String labelYtd;
  final String labelFullPeriod;
  final KpiPeriods profit;
  final KpiPeriods revenue;
  final KpiPeriods biayaRatio;
  final double receivableOutstanding;
  final double collectionRate;
  final double profitMargin;
  final double expenseRatio;

  const KpiData({
    this.labelThisMonth = '',
    this.labelYtd = '',
    this.labelFullPeriod = '',
    this.profit = const KpiPeriods(),
    this.revenue = const KpiPeriods(),
    this.biayaRatio = const KpiPeriods(),
    this.receivableOutstanding = 0,
    this.collectionRate = 0,
    this.profitMargin = 0,
    this.expenseRatio = 0,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    final labels = (json['labels'] as Map?) ?? const {};
    return KpiData(
      labelThisMonth: labels['this_month']?.toString() ?? '',
      labelYtd: labels['ytd']?.toString() ?? '',
      labelFullPeriod: labels['full_period']?.toString() ?? '',
      profit: KpiPeriods.fromJson(json['profit']),
      revenue: KpiPeriods.fromJson(json['revenue']),
      biayaRatio: KpiPeriods.fromJson(json['biaya_ratio']),
      receivableOutstanding: _parseDouble(json['receivable_outstanding']),
      collectionRate: _parseDouble(json['collection_rate']),
      profitMargin: _parseDouble(json['profit_margin']),
      expenseRatio: _parseDouble(json['expense_ratio']),
    );
  }
}

class FilterInfo {
  final String startDate;
  final String endDate;

  FilterInfo({required this.startDate, required this.endDate});

  factory FilterInfo.fromJson(Map<String, dynamic> json) => FilterInfo(
    startDate: json['start_date']?.toString() ?? '',
    endDate: json['end_date']?.toString() ?? '',
  );
}

class AccountingDashboardResponse {
  final FilterInfo filter;
  final AccountingSummary summary;
  final AccountingCharts charts;
  final List<TopListData> topRevenue;
  final List<TopListData> topExpense;
  final List<AgingData> agingPiutang;
  final List<AgingData> agingUtang;
  final List<SalesBreakdownData> customerCategory;
  final List<SalesBreakdownData> topCustomers;
  final KpiData kpi;

  AccountingDashboardResponse({
    required this.filter,
    required this.summary,
    required this.charts,
    required this.topRevenue,
    required this.topExpense,
    required this.agingPiutang,
    required this.agingUtang,
    required this.customerCategory,
    required this.topCustomers,
    required this.kpi,
  });

  factory AccountingDashboardResponse.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) =>
        (json[key] as List? ?? [])
            .map((e) => parse(e as Map<String, dynamic>))
            .toList();

    return AccountingDashboardResponse(
      filter: FilterInfo.fromJson(json['filter'] ?? {}),
      summary: AccountingSummary.fromJson(json['summary'] ?? {}),
      charts: AccountingCharts.fromJson(json['charts'] ?? {}),
      topRevenue: list('top_revenue', TopListData.fromJson),
      topExpense: list('top_expense', TopListData.fromJson),
      agingPiutang: list('aging_piutang', AgingData.fromJson),
      agingUtang: list('aging_utang', AgingData.fromJson),
      customerCategory: list('customer_category', SalesBreakdownData.fromJson),
      topCustomers: list('top_customers', SalesBreakdownData.fromJson),
      kpi: KpiData.fromJson((json['kpi'] as Map?)?.cast<String, dynamic>() ?? {}),
    );
  }
}