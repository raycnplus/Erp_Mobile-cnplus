class LocationReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LocationReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LocationReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return LocationReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class LocationReportModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final String parentName;
  final int totalProduct;
  final int incoming;
  final int outgoing;

  LocationReportModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.parentName,
    required this.totalProduct,
    required this.incoming,
    required this.outgoing,
  });

  factory LocationReportModel.fromJson(Map<String, dynamic> json) {
    return LocationReportModel(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['warehouse_name'] ?? '-',
      parentName: json['parent_name'] ?? '-',
      totalProduct: int.tryParse('${json['total_product'] ?? 0}') ?? 0,
      incoming: int.tryParse('${json['incoming'] ?? 0}') ?? 0,
      outgoing: int.tryParse('${json['outgoing'] ?? 0}') ?? 0,
    );
  }
}

class LocationStockModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final double stockQty;
  final double reservedQty;
  final double onHand;
  final String? uomName;

  LocationStockModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.stockQty,
    required this.reservedQty,
    required this.onHand,
    this.uomName,
  });

  factory LocationStockModel.fromJson(Map<String, dynamic> json) {
    return LocationStockModel(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      stockQty: double.tryParse('${json['stock_qty'] ?? 0}') ?? 0,
      reservedQty: double.tryParse('${json['reserved_qty'] ?? 0}') ?? 0,
      onHand: double.tryParse('${json['on_hand'] ?? 0}') ?? 0,
      uomName: json['uom_name'],
    );
  }
}

class LocationReportDetailModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String? warehouseName;
  final String? parentName;
  final List<LocationStockModel> stocks;

  LocationReportDetailModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    this.warehouseName,
    this.parentName,
    required this.stocks,
  });

  factory LocationReportDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List<dynamic> stockList = data['stocks'] ?? [];
    return LocationReportDetailModel(
      idLocation: data['id_location'] ?? 0,
      locationName: data['location_name'] ?? '',
      locationCode: data['location_code'] ?? '',
      warehouseName: data['warehouse_name'],
      parentName: data['parent_name'],
      stocks: stockList.map((e) => LocationStockModel.fromJson(e)).toList(),
    );
  }
}

class WarehouseOptionModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseOptionModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseOptionModel.fromJson(Map<String, dynamic> json) {
    return WarehouseOptionModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}
