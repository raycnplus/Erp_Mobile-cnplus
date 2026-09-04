class TopCustomerReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  TopCustomerReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory TopCustomerReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return TopCustomerReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class TopCustomerReportSummary {
  final String totalAmountRaw;
  final int totalTransaction;

  TopCustomerReportSummary({
    required this.totalAmountRaw,
    required this.totalTransaction,
  });

  factory TopCustomerReportSummary.fromJson(Map<String, dynamic> json) {
    return TopCustomerReportSummary(
      totalAmountRaw: '${json['total_amount'] ?? 0}',
      totalTransaction: json['total_transaction'] ?? 0,
    );
  }
}

class TopCustomerReportModel {
  final int? idCustomer;
  final String customer;
  final String warehouse;
  final String location;
  final int totalTransaction;
  final String totalAmountRaw;

  TopCustomerReportModel({
    this.idCustomer,
    required this.customer,
    required this.warehouse,
    required this.location,
    required this.totalTransaction,
    required this.totalAmountRaw,
  });

  factory TopCustomerReportModel.fromJson(Map<String, dynamic> json) {
    return TopCustomerReportModel(
      idCustomer: json['id_customer'],
      customer: json['customer'] ?? '-',
      warehouse: json['warehouse'] ?? '-',
      location: json['location'] ?? '-',
      totalTransaction: json['total_transaction'] ?? 0,
      totalAmountRaw: '${json['total_amount'] ?? 0}',
    );
  }
}

class TopCustomerWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  TopCustomerWarehouseOption({required this.idWarehouse, required this.warehouseName});

  factory TopCustomerWarehouseOption.fromJson(Map<String, dynamic> json) {
    return TopCustomerWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class TopCustomerLocationOption {
  final int idLocation;
  final String locationName;

  TopCustomerLocationOption({required this.idLocation, required this.locationName});

  factory TopCustomerLocationOption.fromJson(Map<String, dynamic> json) {
    return TopCustomerLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}