class ServiceSalesOrderReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceSalesOrderReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ServiceSalesOrderReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ServiceSalesOrderReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ServiceSalesOrderReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  ServiceSalesOrderReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory ServiceSalesOrderReportSummary.fromJson(Map<String, dynamic> json) {
    return ServiceSalesOrderReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class ServiceSalesOrderReportModel {
  final int idServiceSalesOrder;
  final String reference;
  final String customer;
  final String salesPerson;
  final String service;
  final double qty;
  final double taxes;
  final double amount;
  final String amountRaw; // dipakai untuk format Rupiah presisi dari backend
  final String paymentStatus;
  final String status;
  final String? createdDate;

  ServiceSalesOrderReportModel({
    required this.idServiceSalesOrder,
    required this.reference,
    required this.customer,
    required this.salesPerson,
    required this.service,
    required this.qty,
    required this.taxes,
    required this.amount,
    required this.amountRaw,
    required this.paymentStatus,
    required this.status,
    this.createdDate,
  });

  factory ServiceSalesOrderReportModel.fromJson(Map<String, dynamic> json) {
    return ServiceSalesOrderReportModel(
      idServiceSalesOrder: json['id_service_sales_order'] ?? 0,
      reference: json['reference'] ?? '-',
      customer: json['customer'] ?? '-',
      salesPerson: json['sales_person'] ?? '-',
      service: json['service'] ?? '-',
      qty: double.tryParse('${json['qty'] ?? 0}') ?? 0,
      taxes: double.tryParse('${json['taxes'] ?? 0}') ?? 0,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      amountRaw: '${json['amount'] ?? 0}',
      paymentStatus: json['payment_status'] ?? '-',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class ServiceSalesOrderCustomerOption {
  final int idCustomer;
  final String customerName;

  ServiceSalesOrderCustomerOption({
    required this.idCustomer,
    required this.customerName,
  });

  factory ServiceSalesOrderCustomerOption.fromJson(Map<String, dynamic> json) {
    return ServiceSalesOrderCustomerOption(
      idCustomer: json['id_customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
    );
  }
}

class ServiceSalesOrderSalesPersonOption {
  final int idUser;
  final String namaLengkap;

  ServiceSalesOrderSalesPersonOption({
    required this.idUser,
    required this.namaLengkap,
  });

  factory ServiceSalesOrderSalesPersonOption.fromJson(Map<String, dynamic> json) {
    return ServiceSalesOrderSalesPersonOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}