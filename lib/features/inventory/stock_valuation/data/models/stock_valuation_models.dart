class StockValuationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  StockValuationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory StockValuationPaginationMeta.fromJson(Map<String, dynamic> json) {
    return StockValuationPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class StockValuationSummary {
  final double grandTotalQty;
  final double grandTotalValue;

  StockValuationSummary({
    required this.grandTotalQty,
    required this.grandTotalValue,
  });

  factory StockValuationSummary.fromJson(Map<String, dynamic> json) {
    return StockValuationSummary(
      grandTotalQty: double.tryParse('${json['grand_total_qty'] ?? 0}') ?? 0,
      grandTotalValue:
          double.tryParse('${json['grand_total_value'] ?? 0}') ?? 0,
    );
  }
}

class StockValuationModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final String? uomName;
  final String? costingMethod;
  final double totalQty;
  final double avgCost;
  final double totalValue;

  StockValuationModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    this.uomName,
    this.costingMethod,
    required this.totalQty,
    required this.avgCost,
    required this.totalValue,
  });

  factory StockValuationModel.fromJson(Map<String, dynamic> json) {
    return StockValuationModel(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      uomName: json['uom_name'],
      costingMethod: json['costing_method'],
      totalQty: double.tryParse('${json['total_qty'] ?? 0}') ?? 0,
      avgCost: double.tryParse('${json['avg_cost'] ?? 0}') ?? 0,
      totalValue: double.tryParse('${json['total_value'] ?? 0}') ?? 0,
    );
  }
}

class StockValuationByLocationModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final String warehouseName;
  final String locationName;
  final double stockQty;
  final String? costingMethod;
  final double avgCost;
  final double locationValue;

  StockValuationByLocationModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.warehouseName,
    required this.locationName,
    required this.stockQty,
    this.costingMethod,
    required this.avgCost,
    required this.locationValue,
  });

  factory StockValuationByLocationModel.fromJson(Map<String, dynamic> json) {
    return StockValuationByLocationModel(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      locationName: json['location_name'] ?? '',
      stockQty: double.tryParse('${json['stock_qty'] ?? 0}') ?? 0,
      costingMethod: json['costing_method'],
      avgCost: double.tryParse('${json['avg_cost'] ?? 0}') ?? 0,
      locationValue: double.tryParse('${json['location_value'] ?? 0}') ?? 0,
    );
  }
}

class StockValuationDetailModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final List<StockValuationByLocationModel> byLocation;
  final double totalQty;
  final double totalValue;

  StockValuationDetailModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.byLocation,
    required this.totalQty,
    required this.totalValue,
  });

  factory StockValuationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final product = data['product'] ?? {};
    final List<dynamic> list = data['by_location'] ?? [];
    return StockValuationDetailModel(
      idProduct: product['id_product'] ?? 0,
      productCode: product['product_code'] ?? '',
      productName: product['product_name'] ?? '',
      byLocation: list
          .map((e) => StockValuationByLocationModel.fromJson(e))
          .toList(),
      totalQty: double.tryParse('${data['total_qty'] ?? 0}') ?? 0,
      totalValue: double.tryParse('${data['total_value'] ?? 0}') ?? 0,
    );
  }
}
