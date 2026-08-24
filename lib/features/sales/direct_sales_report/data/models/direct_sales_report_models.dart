class DirectSalesReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  DirectSalesReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory DirectSalesReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return DirectSalesReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class DirectSalesReportSummary {
  final double totalTaxes;
  final double totalAmount;
  final String totalTaxesRaw;
  final String totalAmountRaw;

  DirectSalesReportSummary({
    required this.totalTaxes,
    required this.totalAmount,
    required this.totalTaxesRaw,
    required this.totalAmountRaw,
  });

  factory DirectSalesReportSummary.fromJson(Map<String, dynamic> json) {
    return DirectSalesReportSummary(
      totalTaxes: double.tryParse('${json['total_taxes'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      totalTaxesRaw: '${json['total_taxes'] ?? 0}',
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class DirectSalesReportModel {
  final int idDirectSales;
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

  DirectSalesReportModel({
    required this.idDirectSales,
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

  factory DirectSalesReportModel.fromJson(Map<String, dynamic> json) {
    return DirectSalesReportModel(
      idDirectSales: json['id_direct_sales'] ?? 0,
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

class DirectSalesWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  DirectSalesWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory DirectSalesWarehouseOption.fromJson(Map<String, dynamic> json) {
    return DirectSalesWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class DirectSalesLocationOption {
  final int idLocation;
  final String locationName;

  DirectSalesLocationOption({
    required this.idLocation,
    required this.locationName,
  });

  factory DirectSalesLocationOption.fromJson(Map<String, dynamic> json) {
    return DirectSalesLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}