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

  TopListData({required this.title, required this.value});

  factory TopListData.fromJson(Map<String, dynamic> json) {
    return TopListData(
      title: json['reference']?.toString() ?? json['title']?.toString() ?? '',
      value: json['total_amount']?.toString() ?? json['value']?.toString() ?? '',
    );
  }
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
    bln1_6:   _parseDouble(json['bln_1_6']),
    bln6_12:  _parseDouble(json['bln_6_12']),
    bln12_24: _parseDouble(json['bln_12_24']),
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

  AccountingCharts({required this.revenue, required this.expense});

  factory AccountingCharts.fromJson(Map<String, dynamic> json) => AccountingCharts(
    revenue: (json['revenue'] as List? ?? [])
        .map((e) => RevenueExpenseData.fromJson(e as Map<String, dynamic>))
        .toList(),
    expense: (json['expense'] as List? ?? [])
        .map((e) => RevenueExpenseData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
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

  AccountingDashboardResponse({
    required this.filter,
    required this.summary,
    required this.charts,
    required this.topRevenue,
    required this.topExpense,
    required this.agingPiutang,
    required this.agingUtang,
  });

  factory AccountingDashboardResponse.fromJson(Map<String, dynamic> json) {
    return AccountingDashboardResponse(
      filter: FilterInfo.fromJson(json['filter'] ?? {}),
      summary: AccountingSummary.fromJson(json['summary'] ?? {}),
      charts: AccountingCharts.fromJson(json['charts'] ?? {}),
      topRevenue: (json['top_revenue'] as List? ?? [])
          .map((e) => TopListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      topExpense: (json['top_expense'] as List? ?? [])
          .map((e) => TopListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      agingPiutang: (json['aging_piutang'] as List? ?? [])
          .map((e) => AgingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      agingUtang: (json['aging_utang'] as List? ?? [])
          .map((e) => AgingData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}