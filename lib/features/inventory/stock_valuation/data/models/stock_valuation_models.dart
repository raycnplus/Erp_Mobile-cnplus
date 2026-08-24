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

class StockValuationWarehouseModel {
  final int idWarehouse;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String totalValuationRaw;

  StockValuationWarehouseModel({
    required this.idWarehouse,
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
    required this.totalValuationRaw,
  });

  factory StockValuationWarehouseModel.fromJson(Map<String, dynamic> json) {
    return StockValuationWarehouseModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
      totalValuationRaw: '${json['total_valuation'] ?? 0}',
    );
  }
}

class StockValuationItemModel {
  final int idLocation;
  final String locationName;
  final int idProduct;
  final String productCode;
  final String productName;
  final String baseUomName;
  final String purchasePriceRaw;
  final String totalStockRaw;
  final String totalOnHandRaw;
  final String totalValueRaw;

  StockValuationItemModel({
    required this.idLocation,
    required this.locationName,
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.baseUomName,
    required this.purchasePriceRaw,
    required this.totalStockRaw,
    required this.totalOnHandRaw,
    required this.totalValueRaw,
  });

  factory StockValuationItemModel.fromJson(Map<String, dynamic> json) {
    return StockValuationItemModel(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      baseUomName: json['base_uom_name'] ?? '-',
      purchasePriceRaw: '${json['purchase_price'] ?? 0}',
      totalStockRaw: '${json['total_stock'] ?? 0}',
      totalOnHandRaw: '${json['total_on_hand'] ?? 0}',
      totalValueRaw: '${json['total_value'] ?? 0}',
    );
  }
}

class StockValuationDetailModel {
  final int idWarehouse;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String totalStockRaw;
  final String totalValueRaw;
  final List<StockValuationItemModel> items;
  final StockValuationPaginationMeta itemsMeta;

  StockValuationDetailModel({
    required this.idWarehouse,
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
    required this.totalStockRaw,
    required this.totalValueRaw,
    required this.items,
    required this.itemsMeta,
  });

  factory StockValuationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final warehouse = data['warehouse'] ?? {};
    final summary = data['summary'] ?? {};
    final itemsPaginator = data['items'] as Map<String, dynamic>? ?? {};
    final List<dynamic> itemList = itemsPaginator['data'] ?? [];

    return StockValuationDetailModel(
      idWarehouse: warehouse['id_warehouse'] ?? 0,
      warehouseName: warehouse['warehouse_name'] ?? '',
      warehouseCode: warehouse['warehouse_code'] ?? '',
      branch: warehouse['branch'],
      totalStockRaw: '${summary['total_stock'] ?? 0}',
      totalValueRaw: '${summary['total_value'] ?? 0}',
      items: itemList.map((e) => StockValuationItemModel.fromJson(e)).toList(),
      itemsMeta: StockValuationPaginationMeta.fromJson(itemsPaginator),
    );
  }
}

class StockValuationBranchOption {
  final String branch;
  StockValuationBranchOption(this.branch);
}