class WarehouseReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  WarehouseReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WarehouseReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return WarehouseReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class WarehouseReportModel {
  final int idWarehouse;
  final String warehouseName;
  final String warehouseCode;
  final int totalLocation;
  final int totalProduct;
  final double onHand;
  final double forecastedIncoming;

  WarehouseReportModel({
    required this.idWarehouse,
    required this.warehouseName,
    required this.warehouseCode,
    required this.totalLocation,
    required this.totalProduct,
    required this.onHand,
    required this.forecastedIncoming,
  });

  factory WarehouseReportModel.fromJson(Map<String, dynamic> json) {
    return WarehouseReportModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      totalLocation: int.tryParse('${json['total_location'] ?? 0}') ?? 0,
      totalProduct: int.tryParse('${json['total_product'] ?? 0}') ?? 0,
      onHand: double.tryParse('${json['on_hand'] ?? 0}') ?? 0,
      forecastedIncoming:
          double.tryParse('${json['forecasted_incoming'] ?? 0}') ?? 0,
    );
  }
}

class WarehouseLocationModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final int totalProduct;
  final double totalStock;

  WarehouseLocationModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.totalProduct,
    required this.totalStock,
  });

  factory WarehouseLocationModel.fromJson(Map<String, dynamic> json) {
    return WarehouseLocationModel(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      totalProduct: int.tryParse('${json['total_product'] ?? 0}') ?? 0,
      totalStock: double.tryParse('${json['total_stock'] ?? 0}') ?? 0,
    );
  }
}

class WarehouseReportDetailModel {
  final int idWarehouse;
  final String warehouseName;
  final String warehouseCode;
  final double totalOnHand;
  final List<WarehouseLocationModel> locations;

  WarehouseReportDetailModel({
    required this.idWarehouse,
    required this.warehouseName,
    required this.warehouseCode,
    required this.totalOnHand,
    required this.locations,
  });

  factory WarehouseReportDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List<dynamic> locList = data['locations'] ?? [];
    return WarehouseReportDetailModel(
      idWarehouse: data['id_warehouse'] ?? 0,
      warehouseName: data['warehouse_name'] ?? '',
      warehouseCode: data['warehouse_code'] ?? '',
      totalOnHand: double.tryParse('${data['total_on_hand'] ?? 0}') ?? 0,
      locations: locList
          .map((e) => WarehouseLocationModel.fromJson(e))
          .toList(),
    );
  }
}
