class ServiceInvoiceReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceInvoiceReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ServiceInvoiceReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ServiceInvoiceReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ServiceInvoiceReportSummary {
  final double totalUntaxed;
  final double totalTaxes;
  final double totalGrand;
  final String totalUntaxedRaw;
  final String totalTaxesRaw;
  final String totalGrandRaw;

  ServiceInvoiceReportSummary({
    required this.totalUntaxed,
    required this.totalTaxes,
    required this.totalGrand,
    required this.totalUntaxedRaw,
    required this.totalTaxesRaw,
    required this.totalGrandRaw,
  });

  factory ServiceInvoiceReportSummary.fromJson(Map<String, dynamic> json) {
    return ServiceInvoiceReportSummary(
      totalUntaxed: double.tryParse('${json['total_untaxed'] ?? 0}') ?? 0,
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalGrand: double.tryParse('${json['total_grand'] ?? 0}') ?? 0,
      totalUntaxedRaw: '${json['total_untaxed'] ?? 0}',
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalGrandRaw: '${json['total_grand'] ?? 0}',
    );
  }
}

class ServiceInvoiceReportModel {
  final int idServiceInvoice;
  final String reference;
  final String customer;
  final String salesPerson;
  final String service;
  final double qty;
  final double untaxedAmount;
  final double taxes;
  final double grandTotal;
  final String grandTotalRaw; // dipakai untuk format Rupiah presisi dari backend
  final String status;
  final String? createdDate;

  ServiceInvoiceReportModel({
    required this.idServiceInvoice,
    required this.reference,
    required this.customer,
    required this.salesPerson,
    required this.service,
    required this.qty,
    required this.untaxedAmount,
    required this.taxes,
    required this.grandTotal,
    required this.grandTotalRaw,
    required this.status,
    this.createdDate,
  });

  factory ServiceInvoiceReportModel.fromJson(Map<String, dynamic> json) {
    return ServiceInvoiceReportModel(
      idServiceInvoice: json['id_service_invoice'] ?? 0,
      reference: json['reference'] ?? '-',
      customer: json['customer'] ?? '-',
      salesPerson: json['sales_person'] ?? '-',
      service: json['service'] ?? '-',
      qty: double.tryParse('${json['qty'] ?? 0}') ?? 0,
      untaxedAmount: double.tryParse('${json['untaxed_amount'] ?? 0}') ?? 0,
      taxes: double.tryParse('${json['taxes'] ?? 0}') ?? 0,
      grandTotal: double.tryParse('${json['grand_total'] ?? 0}') ?? 0,
      grandTotalRaw: '${json['grand_total'] ?? 0}',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class ServiceInvoiceCustomerOption {
  final int idCustomer;
  final String customerName;

  ServiceInvoiceCustomerOption({
    required this.idCustomer,
    required this.customerName,
  });

  factory ServiceInvoiceCustomerOption.fromJson(Map<String, dynamic> json) {
    return ServiceInvoiceCustomerOption(
      idCustomer: json['id_customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
    );
  }
}

class ServiceInvoiceSalesPersonOption {
  final int idUser;
  final String namaLengkap;

  ServiceInvoiceSalesPersonOption({
    required this.idUser,
    required this.namaLengkap,
  });

  factory ServiceInvoiceSalesPersonOption.fromJson(Map<String, dynamic> json) {
    return ServiceInvoiceSalesPersonOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}