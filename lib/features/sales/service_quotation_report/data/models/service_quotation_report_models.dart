class ServiceQuotationReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceQuotationReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ServiceQuotationReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ServiceQuotationReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ServiceQuotationReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  ServiceQuotationReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory ServiceQuotationReportSummary.fromJson(Map<String, dynamic> json) {
    return ServiceQuotationReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class ServiceQuotationReportModel {
  final int idServiceQuotation;
  final String reference;
  final String customer;
  final String salesPerson;
  final String service;
  final double qty;
  final double taxes;
  final double amount;
  final String amountRaw; // dipakai untuk format Rupiah presisi dari backend
  final String status;
  final String? createdDate;

  ServiceQuotationReportModel({
    required this.idServiceQuotation,
    required this.reference,
    required this.customer,
    required this.salesPerson,
    required this.service,
    required this.qty,
    required this.taxes,
    required this.amount,
    required this.amountRaw,
    required this.status,
    this.createdDate,
  });

  factory ServiceQuotationReportModel.fromJson(Map<String, dynamic> json) {
    return ServiceQuotationReportModel(
      idServiceQuotation: json['id_service_quotation'] ?? 0,
      reference: json['reference'] ?? '-',
      customer: json['customer'] ?? '-',
      salesPerson: json['sales_person'] ?? '-',
      service: json['service'] ?? '-',
      qty: double.tryParse('${json['qty'] ?? 0}') ?? 0,
      taxes: double.tryParse('${json['taxes'] ?? 0}') ?? 0,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      amountRaw: '${json['amount'] ?? 0}',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class ServiceQuotationCustomerOption {
  final int idCustomer;
  final String customerName;

  ServiceQuotationCustomerOption({
    required this.idCustomer,
    required this.customerName,
  });

  factory ServiceQuotationCustomerOption.fromJson(Map<String, dynamic> json) {
    return ServiceQuotationCustomerOption(
      idCustomer: json['id_customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
    );
  }
}

class ServiceQuotationSalesPersonOption {
  final int idUser;
  final String namaLengkap;

  ServiceQuotationSalesPersonOption({
    required this.idUser,
    required this.namaLengkap,
  });

  factory ServiceQuotationSalesPersonOption.fromJson(Map<String, dynamic> json) {
    return ServiceQuotationSalesPersonOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}