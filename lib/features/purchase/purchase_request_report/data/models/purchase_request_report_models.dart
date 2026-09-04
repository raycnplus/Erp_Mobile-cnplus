class PurchaseRequestReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PurchaseRequestReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PurchaseRequestReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class PurchaseRequestReportSummary {
  final String totalPriceRaw;
  final int totalRecords;

  PurchaseRequestReportSummary({
    required this.totalPriceRaw,
    required this.totalRecords,
  });

  factory PurchaseRequestReportSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestReportSummary(
      totalPriceRaw: '${json['total_price'] ?? 0}',
      totalRecords: json['total_records'] ?? 0,
    );
  }
}

class PurchaseRequestReportModel {
  final int idPurchaseRequest;
  final String reference;
  final String requestedBy;
  final String destinationWarehouse;
  final String destinationLocation;
  final String totalPriceRaw;
  final String status;
  final String? createdDate;

  PurchaseRequestReportModel({
    required this.idPurchaseRequest,
    required this.reference,
    required this.requestedBy,
    required this.destinationWarehouse,
    required this.destinationLocation,
    required this.totalPriceRaw,
    required this.status,
    this.createdDate,
  });

  factory PurchaseRequestReportModel.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestReportModel(
      idPurchaseRequest: json['id_purchase_request'] ?? 0,
      reference: json['reference'] ?? '-',
      requestedBy: json['requested_by'] ?? '-',
      destinationWarehouse: json['destination_warehouse'] ?? '-',
      destinationLocation: json['destination_location'] ?? '-',
      totalPriceRaw: '${json['total_price'] ?? 0}',
      status: json['status'] ?? '-',
      createdDate: json['created_date_formatted'] ?? json['created_date'],
    );
  }
}

class PurchaseRequestWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  PurchaseRequestWarehouseOption({required this.idWarehouse, required this.warehouseName});

  factory PurchaseRequestWarehouseOption.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class PurchaseRequestLocationOption {
  final int idLocation;
  final String locationName;

  PurchaseRequestLocationOption({required this.idLocation, required this.locationName});

  factory PurchaseRequestLocationOption.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}

class PurchaseRequestRequesterOption {
  final int idUser;
  final String namaLengkap;

  PurchaseRequestRequesterOption({required this.idUser, required this.namaLengkap});

  factory PurchaseRequestRequesterOption.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestRequesterOption(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}