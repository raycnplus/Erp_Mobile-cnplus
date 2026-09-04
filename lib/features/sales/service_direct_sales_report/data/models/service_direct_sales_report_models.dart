class ServiceDirectSalesReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceDirectSalesReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ServiceDirectSalesReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ServiceDirectSalesReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ServiceDirectSalesReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  ServiceDirectSalesReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory ServiceDirectSalesReportSummary.fromJson(Map<String, dynamic> json) {
    return ServiceDirectSalesReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class ServiceDirectSalesReportModel {
  final int idServiceDirectSales;
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

  ServiceDirectSalesReportModel({
    required this.idServiceDirectSales,
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

  factory ServiceDirectSalesReportModel.fromJson(Map<String, dynamic> json) {
    return ServiceDirectSalesReportModel(
      idServiceDirectSales: json['id_service_direct_sales'] ?? 0,
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

class ServiceDirectSalesCustomerOption {
  final int idCustomer;
  final String customerName;

  ServiceDirectSalesCustomerOption({
    required this.idCustomer,
    required this.customerName,
  });

  factory ServiceDirectSalesCustomerOption.fromJson(Map<String, dynamic> json) {
    return ServiceDirectSalesCustomerOption(
      idCustomer: json['id_customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
    );
  }
}

class ServiceDirectSalesSalesPersonOption {
  final int idUser;
  final String namaLengkap;

  ServiceDirectSalesSalesPersonOption({
    required this.idUser,
    required this.namaLengkap,
  });

  factory ServiceDirectSalesSalesPersonOption.fromJson(Map<String, dynamic> json) {
    return ServiceDirectSalesSalesPersonOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}