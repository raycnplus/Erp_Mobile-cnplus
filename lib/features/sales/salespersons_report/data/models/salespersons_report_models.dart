class SalespersonsReportModel {
  final int idUser;
  final String salespersonName;
  final int totalQuotation;
  final int totalSalesOrder;
  final int totalDirectSales;
  final int totalInvoice;
  final double totalInvoiceValue;
  final String totalInvoiceValueRaw; // dipakai untuk format Rupiah presisi dari backend
  final int totalCustomers;
  final int totalServiceInvoice;
  final double totalServiceInvoiceValue;
  final String totalServiceInvoiceValueRaw; // dipakai untuk format Rupiah presisi dari backend
  final int totalServiceCustomers;
  final int totalCustomerHandled;
  final String conversionRate; // mis. "75.00%" atau "-"

  SalespersonsReportModel({
    required this.idUser,
    required this.salespersonName,
    required this.totalQuotation,
    required this.totalSalesOrder,
    required this.totalDirectSales,
    required this.totalInvoice,
    required this.totalInvoiceValue,
    required this.totalInvoiceValueRaw,
    required this.totalCustomers,
    required this.totalServiceInvoice,
    required this.totalServiceInvoiceValue,
    required this.totalServiceInvoiceValueRaw,
    required this.totalServiceCustomers,
    required this.totalCustomerHandled,
    required this.conversionRate,
  });

  factory SalespersonsReportModel.fromJson(Map<String, dynamic> json) {
    return SalespersonsReportModel(
      idUser: json['id_user'] ?? 0,
      salespersonName: json['salesperson_name'] ?? '-',
      totalQuotation: json['total_quotation'] ?? 0,
      totalSalesOrder: json['total_sales_order'] ?? 0,
      totalDirectSales: json['total_direct_sales'] ?? 0,
      totalInvoice: json['total_invoice'] ?? 0,
      totalInvoiceValue: double.tryParse(
            '${json['total_invoice_value'] ?? 0}'.replaceAll(',', ''),
          ) ??
          0,
      totalInvoiceValueRaw: '${json['total_invoice_value'] ?? 0}',
      totalCustomers: json['total_customers'] ?? 0,
      totalServiceInvoice: json['total_service_invoice'] ?? 0,
      totalServiceInvoiceValue: double.tryParse(
            '${json['total_service_invoice_value'] ?? 0}'.replaceAll(',', ''),
          ) ??
          0,
      totalServiceInvoiceValueRaw: '${json['total_service_invoice_value'] ?? 0}',
      totalServiceCustomers: json['total_service_customers'] ?? 0,
      totalCustomerHandled: json['total_customer_handled'] ?? 0,
      conversionRate: json['conversion_rate'] ?? '-',
    );
  }
}

class SalespersonOption {
  final int idUser;
  final String salespersonName;

  SalespersonOption({
    required this.idUser,
    required this.salespersonName,
  });
}