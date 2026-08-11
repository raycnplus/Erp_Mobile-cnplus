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

class SalesChartData {
  final String label;
  final double value;

  SalesChartData({required this.label, required this.value});
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

  factory TopCustomer.fromJson(Map<String, dynamic> json) => TopCustomer(
        customerName: json['customer_name']?.toString() ?? '',
        categoryName: json['category_name']?.toString() ?? '',
        totalAmount:  _parseDouble(json['total_amount']),
      );
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

  factory TopInvoice.fromJson(Map<String, dynamic> json) => TopInvoice(
        reference:    json['reference']?.toString()     ?? '',
        customerName: json['customer_name']?.toString() ?? '',
        grandTotal:   _parseDouble(json['grand_total']),
      );
}

class SalesPerDate {
  final String date;
  final int    orderCount;
  final double totalAmount;

  SalesPerDate({
    required this.date,
    required this.orderCount,
    required this.totalAmount,
  });

  factory SalesPerDate.fromJson(Map<String, dynamic> json) => SalesPerDate(
        date:        json['date']?.toString() ?? '',
        orderCount:  _parseInt(json['order_count']),
        totalAmount: _parseDouble(json['total_amount']),
      );
}

class SalesPerProduct {
  final String productName;
  final double qtyTotal;
  final double totalAmount;

  SalesPerProduct({
    required this.productName,
    required this.qtyTotal,
    required this.totalAmount,
  });

  factory SalesPerProduct.fromJson(Map<String, dynamic> json) => SalesPerProduct(
        productName: json['product_name']?.toString() ?? '',
        qtyTotal:    _parseDouble(json['qty_total']),
        totalAmount: _parseDouble(json['total_amount']),
      );
}

class SalesPerCustomer {
  final String customerName;
  final int    orderCount;
  final double totalAmount;

  SalesPerCustomer({
    required this.customerName,
    required this.orderCount,
    required this.totalAmount,
  });

  factory SalesPerCustomer.fromJson(Map<String, dynamic> json) => SalesPerCustomer(
        customerName: json['customer_name']?.toString() ?? '',
        orderCount:   _parseInt(json['order_count']),
        totalAmount:  _parseDouble(json['total_amount']),
      );
}

class SalesPerSalesperson {
  final String salespersonName;
  final int    orderCount;
  final double totalAmount;

  SalesPerSalesperson({
    required this.salespersonName,
    required this.orderCount,
    required this.totalAmount,
  });

  factory SalesPerSalesperson.fromJson(Map<String, dynamic> json) => SalesPerSalesperson(
        salespersonName: json['salesperson_name']?.toString() ?? '',
        orderCount:      _parseInt(json['order_count']),
        totalAmount:     _parseDouble(json['total_amount']),
      );
}

class SalesDashboardResponse {
  final int    quotation;
  final int    salesOrder;
  final int    directSales;
  final int    invoice;
  final double grandTotal;
  final double profit;
  final int    salesProductCount;
  final List<SalesChartData>     revenuePerDay;
  final List<SalesChartData>     quantityPerDay;
  final List<TopCustomer>        topCustomers;
  final List<TopInvoice>         topInvoices;
  final List<SalesPerDate>       salesPerDate;
  final List<SalesPerProduct>    salesPerProduct;
  final List<SalesPerCustomer>   salesPerCustomer;
  final List<SalesPerSalesperson> salesPerSalesperson;

  SalesDashboardResponse({
    required this.quotation,
    required this.salesOrder,
    required this.directSales,
    required this.invoice,
    required this.grandTotal,
    required this.profit,
    required this.salesProductCount,
    required this.revenuePerDay,
    required this.quantityPerDay,
    required this.topCustomers,
    required this.topInvoices,
    required this.salesPerDate,
    required this.salesPerProduct,
    required this.salesPerCustomer,
    required this.salesPerSalesperson,
  });

  factory SalesDashboardResponse.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    final charts  = json['charts']  as Map<String, dynamic>? ?? {};

    return SalesDashboardResponse(
      quotation:         _parseInt(summary['quotation']),
      salesOrder:        _parseInt(summary['sales_order']),
      directSales:       _parseInt(summary['direct_sales']),
      invoice:           _parseInt(summary['invoice']),
      grandTotal:        _parseDouble(summary['grand_total']),
      profit:            _parseDouble(summary['profit']),
      salesProductCount: _parseInt(summary['sales_product_count']),
      revenuePerDay:     _parseChart(charts['revenue_per_day']),
      quantityPerDay:    _parseChart(charts['quantity_per_day']),
      topCustomers: (json['top_customers'] as List? ?? [])
          .map((e) => TopCustomer.fromJson(e as Map<String, dynamic>))
          .toList(),
      topInvoices: (json['top_invoices'] as List? ?? [])
          .map((e) => TopInvoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesPerDate: (json['sales_per_day'] as List? ?? [])
          .map((e) => SalesPerDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesPerProduct: (json['sales_per_product'] as List? ?? [])
          .map((e) => SalesPerProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesPerCustomer: (json['sales_per_customer'] as List? ?? [])
          .map((e) => SalesPerCustomer.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesPerSalesperson: (json['sales_per_salesperson'] as List? ?? [])
          .map((e) => SalesPerSalesperson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<SalesChartData> _parseChart(dynamic chart) {
    if (chart == null) return [];
    final labels = chart['labels'] as List? ?? [];
    final data   = chart['data']   as List? ?? [];
    final length = labels.length < data.length ? labels.length : data.length;
    return List.generate(
      length,
      (i) => SalesChartData(
        label: labels[i].toString(),
        value: _parseDouble(data[i]),
      ),
    );
  }
}