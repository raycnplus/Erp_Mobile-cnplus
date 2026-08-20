class ExpiredReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ExpiredReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ExpiredReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ExpiredReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ExpiredReportModel {
  final int idProductLotSerial;
  final String lotSerialNumber;
  final String productCode;
  final String productName;
  final String? warehouseName;
  final String? locationName;
  final String? uomName;
  final double remainingQuantity;
  final String? expirationDate;
  final String? bestBeforeDate;
  final String? removalDate;
  final String? alertDate;
  final int? daysToExpiry;
  final String expiryStatus;

  ExpiredReportModel({
    required this.idProductLotSerial,
    required this.lotSerialNumber,
    required this.productCode,
    required this.productName,
    this.warehouseName,
    this.locationName,
    this.uomName,
    required this.remainingQuantity,
    this.expirationDate,
    this.bestBeforeDate,
    this.removalDate,
    this.alertDate,
    this.daysToExpiry,
    required this.expiryStatus,
  });

  factory ExpiredReportModel.fromJson(Map<String, dynamic> json) {
    return ExpiredReportModel(
      idProductLotSerial: json['id_product_lot_serial'] ?? 0,
      lotSerialNumber: json['lot_serial_number'] ?? '',
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      warehouseName: json['warehouse_name'],
      locationName: json['location_name'],
      uomName: json['uom_name'],
      remainingQuantity:
          double.tryParse('${json['remaining_quantity'] ?? 0}') ?? 0,
      expirationDate:
          json['expiration_date_formatted'] ?? json['expiration_date'],
      bestBeforeDate:
          json['best_before_date_formatted'] ?? json['best_before_date'],
      removalDate: json['removal_date_formatted'] ?? json['removal_date'],
      alertDate: json['alert_date_formatted'] ?? json['alert_date'],
      daysToExpiry: json['days_to_expiry'] != null
          ? int.tryParse('${json['days_to_expiry']}')
          : null,
      expiryStatus: json['expiry_status'] ?? '-',
    );
  }
}

class ExpiredWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  ExpiredWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory ExpiredWarehouseOption.fromJson(Map<String, dynamic> json) {
    return ExpiredWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class ExpiredLocationOption {
  final int idLocation;
  final String locationName;

  ExpiredLocationOption({required this.idLocation, required this.locationName});

  factory ExpiredLocationOption.fromJson(Map<String, dynamic> json) {
    return ExpiredLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}
