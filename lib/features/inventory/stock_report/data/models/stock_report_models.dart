class StockReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  StockReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory StockReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return StockReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class StockReportModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final double onHand;
  final double reserved;
  final double available;
  final double forecastedIncoming;
  final double forecastedOutgoing;

  StockReportModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.onHand,
    required this.reserved,
    required this.available,
    required this.forecastedIncoming,
    required this.forecastedOutgoing,
  });

  factory StockReportModel.fromJson(Map<String, dynamic> json) {
    return StockReportModel(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      onHand: double.tryParse('${json['on_hand'] ?? 0}') ?? 0,
      reserved: double.tryParse('${json['reserved'] ?? 0}') ?? 0,
      available: double.tryParse('${json['available'] ?? 0}') ?? 0,
      forecastedIncoming:
          double.tryParse('${json['forecasted_incoming'] ?? 0}') ?? 0,
      forecastedOutgoing:
          double.tryParse('${json['forecasted_outgoing'] ?? 0}') ?? 0,
    );
  }
}

class StockByLocationModel {
  final int idLocation;
  final String locationName;
  final int idWarehouse;
  final String warehouseName;
  final double stockQty;
  final double reservedQty;
  final double available;

  StockByLocationModel({
    required this.idLocation,
    required this.locationName,
    required this.idWarehouse,
    required this.warehouseName,
    required this.stockQty,
    required this.reservedQty,
    required this.available,
  });

  factory StockByLocationModel.fromJson(Map<String, dynamic> json) {
    return StockByLocationModel(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      stockQty: double.tryParse('${json['stock_qty'] ?? 0}') ?? 0,
      reservedQty: double.tryParse('${json['reserved_qty'] ?? 0}') ?? 0,
      available: double.tryParse('${json['available'] ?? 0}') ?? 0,
    );
  }
}

class StockReportDetailModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final String? uomName;
  final List<StockByLocationModel> stockByLocation;

  StockReportDetailModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    this.uomName,
    required this.stockByLocation,
  });

  factory StockReportDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List<dynamic> list = data['stock_by_location'] ?? [];
    return StockReportDetailModel(
      idProduct: data['id_product'] ?? 0,
      productCode: data['product_code'] ?? '',
      productName: data['product_name'] ?? '',
      uomName: data['uom_name'],
      stockByLocation: list
          .map((e) => StockByLocationModel.fromJson(e))
          .toList(),
    );
  }
}
