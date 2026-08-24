class SalesOrderReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  SalesOrderReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SalesOrderReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return SalesOrderReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class SalesOrderReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  SalesOrderReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory SalesOrderReportSummary.fromJson(Map<String, dynamic> json) {
    return SalesOrderReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class SalesOrderReportModel {
  final int idSalesOrder;
  final String reference;
  final String customer;
  final String salesPerson;
  final String product;
  final double demandQty;
  final double taxes;
  final double amount;
  final String amountRaw; // dipakai untuk format Rupiah presisi dari backend
  final String status;
  final String? createdDate;

  SalesOrderReportModel({
    required this.idSalesOrder,
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

  factory SalesOrderReportModel.fromJson(Map<String, dynamic> json) {
    return SalesOrderReportModel(
      idSalesOrder: json['id_sales_order'] ?? 0,
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

class SalesOrderWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  SalesOrderWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory SalesOrderWarehouseOption.fromJson(Map<String, dynamic> json) {
    return SalesOrderWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class SalesOrderLocationOption {
  final int idLocation;
  final String locationName;

  SalesOrderLocationOption({
    required this.idLocation,
    required this.locationName,
  });

  factory SalesOrderLocationOption.fromJson(Map<String, dynamic> json) {
    return SalesOrderLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}