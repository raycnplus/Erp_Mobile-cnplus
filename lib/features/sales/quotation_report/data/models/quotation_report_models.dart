class QuotationReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  QuotationReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory QuotationReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return QuotationReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class QuotationReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  QuotationReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory QuotationReportSummary.fromJson(Map<String, dynamic> json) {
    return QuotationReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class QuotationReportModel {
  final int idQuotation;
  final String reference;
  final String customer;
  final String salesPerson;
  final String product;
  final double demandQty;
  final double taxes;
  final double amount;
  final String amountRaw; // tambahan
  final String status;
  final String? createdDate;

  QuotationReportModel({
    required this.idQuotation,
    required this.reference,
    required this.customer,
    required this.salesPerson,
    required this.product,
    required this.demandQty,
    required this.taxes,
    required this.amount,
    required this.amountRaw,
    required this.status,
    this.createdDate,
  });

  factory QuotationReportModel.fromJson(Map<String, dynamic> json) {
    return QuotationReportModel(
      idQuotation: json['id_quotation'] ?? 0,
      reference: json['reference'] ?? '-',
      customer: json['customer'] ?? '-',
      salesPerson: json['sales_person'] ?? '-',
      product: json['product'] ?? '-',
      demandQty: double.tryParse('${json['demand_qty'] ?? 0}') ?? 0,
      taxes: double.tryParse('${json['taxes'] ?? 0}') ?? 0,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      amountRaw: '${json['amount'] ?? 0}',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class QuotationWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  QuotationWarehouseOption({required this.idWarehouse, required this.warehouseName});

  factory QuotationWarehouseOption.fromJson(Map<String, dynamic> json) {
    return QuotationWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class QuotationLocationOption {
  final int idLocation;
  final String locationName;

  QuotationLocationOption({required this.idLocation, required this.locationName});

  factory QuotationLocationOption.fromJson(Map<String, dynamic> json) {
    return QuotationLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}