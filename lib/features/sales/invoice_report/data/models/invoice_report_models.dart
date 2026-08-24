class InvoiceReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  InvoiceReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory InvoiceReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return InvoiceReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class InvoiceReportSummary {
  final double totalUntaxed;
  final double totalTaxes;
  final double totalAmount;
  final String totalUntaxedRaw;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  InvoiceReportSummary({
    required this.totalUntaxed,
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalUntaxedRaw,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory InvoiceReportSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceReportSummary(
      totalUntaxed: double.tryParse('${json['total_untaxed'] ?? 0}') ?? 0,
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalUntaxedRaw: '${json['total_untaxed'] ?? 0}',
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class InvoiceReportModel {
  final int idInvoice;
  final String reference;
  final String customer;
  final String salesPerson;
  final String product;
  final double demandQty;
  final double untaxedAmount;
  final double taxes;
  final double amount;
  final String amountRaw; // dipakai untuk format Rupiah presisi dari backend
  final String status;
  final String? createdDate;

  InvoiceReportModel({
    required this.idInvoice,
    required this.reference,
    required this.customer,
    required this.salesPerson,
    required this.product,
    required this.demandQty,
    required this.untaxedAmount,
    required this.taxes,
    required this.amount,
    required this.amountRaw,
    required this.status,
    this.createdDate,
  });

  factory InvoiceReportModel.fromJson(Map<String, dynamic> json) {
    return InvoiceReportModel(
      idInvoice: json['id_invoice'] ?? 0,
      reference: json['reference'] ?? '-',
      customer: json['customer'] ?? '-',
      salesPerson: json['sales_person'] ?? '-',
      product: json['product'] ?? '-',
      demandQty: double.tryParse('${json['demand_qty'] ?? 0}') ?? 0,
      untaxedAmount: double.tryParse('${json['untaxed_amount'] ?? 0}') ?? 0,
      taxes: double.tryParse('${json['taxes'] ?? 0}') ?? 0,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      amountRaw: '${json['amount'] ?? 0}',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class InvoiceSalesPersonOption {
  final int idUser;
  final String namaLengkap;

  InvoiceSalesPersonOption({
    required this.idUser,
    required this.namaLengkap,
  });

  factory InvoiceSalesPersonOption.fromJson(Map<String, dynamic> json) {
    return InvoiceSalesPersonOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}

class InvoiceSourceTypeOption {
  final String value;
  final String label;

  InvoiceSourceTypeOption({
    required this.value,
    required this.label,
  });

  factory InvoiceSourceTypeOption.fromJson(Map<String, dynamic> json) {
    return InvoiceSourceTypeOption(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}