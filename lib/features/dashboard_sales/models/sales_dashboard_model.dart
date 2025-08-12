import 'sales_chart_data_model.dart';

class SalesDashboardResponse {
  final int quotation;
  final int salesOrder;
  final int directSales;
  final int invoice;
  final double grandTotal;
  final int salesProductCount;
  final List<SalesChartData> revenuePerDay;
  final List<SalesChartData> quantityPerDay;
  final List<TopCustomer> topCustomers;
  final List<TopInvoice> topInvoices;

  SalesDashboardResponse({
    required this.quotation,
    required this.salesOrder,
    required this.directSales,
    required this.invoice,
    required this.grandTotal,
    required this.salesProductCount,
    required this.revenuePerDay,
    required this.quantityPerDay,
    required this.topCustomers,
    required this.topInvoices,
  });

  factory SalesDashboardResponse.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};
    final charts = json['charts'] ?? {};
    return SalesDashboardResponse(
      quotation: summary['quotation'] ?? 0,
      salesOrder: summary['sales_order'] ?? 0,
      directSales: summary['direct_sales'] ?? 0,
      invoice: summary['invoice'] ?? 0,
      grandTotal: double.tryParse(summary['grand_total'].toString()) ?? 0,
      salesProductCount: summary['sales_product_count'] ?? 0,
      revenuePerDay: _parseChart(charts['revenue_per_day']),
      quantityPerDay: _parseChart(charts['quantity_per_day']),
      topCustomers: (json['top_customers'] as List<dynamic>? ?? [])
          .map((e) => TopCustomer.fromJson(e)).toList(),
      topInvoices: (json['top_invoices'] as List<dynamic>? ?? [])
          .map((e) => TopInvoice.fromJson(e)).toList(),
    );
  }

  static List<SalesChartData> _parseChart(dynamic chart) {
    if (chart == null) return [];
    final labels = chart['labels'] as List<dynamic>? ?? [];
    final data = chart['data'] as List<dynamic>? ?? [];
    List<SalesChartData> result = [];
    for (int i = 0; i < labels.length && i < data.length; i++) {
      result.add(SalesChartData(
        label: labels[i].toString(),
        value: double.tryParse(data[i].toString()) ?? 0,
      ));
    }
    return result;
  }
}

class TopCustomer {
  final String customerName;
  final String categoryName;
  final double totalAmount;

  TopCustomer({
    required this.customerName,
    required this.categoryName,
    required this.totalAmount,
  });

  factory TopCustomer.fromJson(Map<String, dynamic> json) {
    return TopCustomer(
      customerName: json['customer_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0,
    );
  }
}

class TopInvoice {
  final String reference;
  final String customerName;
  final double grandTotal;

  TopInvoice({
    required this.reference,
    required this.customerName,
    required this.grandTotal,
  });

  factory TopInvoice.fromJson(Map<String, dynamic> json) {
    return TopInvoice(
      reference: json['reference'] ?? '',
      customerName: json['customer_name'] ?? '',
      grandTotal: double.tryParse(json['grand_total'].toString()) ?? 0,
    );
  }
}