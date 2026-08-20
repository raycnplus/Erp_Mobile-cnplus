class HistoryStockPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  HistoryStockPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory HistoryStockPaginationMeta.fromJson(Map<String, dynamic> json) {
    return HistoryStockPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class HistoryStockSummary {
  final double totalIn;
  final double totalOut;
  final double netMovement;
  final int totalRows;

  HistoryStockSummary({
    required this.totalIn,
    required this.totalOut,
    required this.netMovement,
    required this.totalRows,
  });

  factory HistoryStockSummary.fromJson(Map<String, dynamic> json) {
    return HistoryStockSummary(
      totalIn: double.tryParse('${json['total_in'] ?? 0}') ?? 0,
      totalOut: double.tryParse('${json['total_out'] ?? 0}') ?? 0,
      netMovement: double.tryParse('${json['net_movement'] ?? 0}') ?? 0,
      totalRows: json['total_rows'] ?? 0,
    );
  }
}

class HistoryStockModel {
  final int idProduct;
  final String productCode;
  final String productName;
  final String warehouseName;
  final String locationName;
  final String transactionDate;
  final double stockOpening;
  final double stockIn;
  final double stockOut;
  final double stockClosing;
  final String? detailTransactions;

  HistoryStockModel({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    required this.warehouseName,
    required this.locationName,
    required this.transactionDate,
    required this.stockOpening,
    required this.stockIn,
    required this.stockOut,
    required this.stockClosing,
    this.detailTransactions,
  });

  factory HistoryStockModel.fromJson(Map<String, dynamic> json) {
    return HistoryStockModel(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      locationName: json['location_name'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      stockOpening: double.tryParse('${json['stock_opening'] ?? 0}') ?? 0,
      stockIn: double.tryParse('${json['stock_in'] ?? 0}') ?? 0,
      stockOut: double.tryParse('${json['stock_out'] ?? 0}') ?? 0,
      stockClosing: double.tryParse('${json['stock_closing'] ?? 0}') ?? 0,
      detailTransactions: json['detail_transactions'],
    );
  }
}

class HistoryTransactionModel {
  final String movementDate;
  final String reference;
  final String productCode;
  final String productName;
  final String warehouseName;
  final String locationName;
  final String movementType;
  final double qty;

  HistoryTransactionModel({
    required this.movementDate,
    required this.reference,
    required this.productCode,
    required this.productName,
    required this.warehouseName,
    required this.locationName,
    required this.movementType,
    required this.qty,
  });

  factory HistoryTransactionModel.fromJson(Map<String, dynamic> json) {
    return HistoryTransactionModel(
      movementDate:
          json['movement_date_formatted'] ?? json['movement_date'] ?? '',
      reference: json['reference'] ?? '-',
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      locationName: json['location_name'] ?? '',
      movementType: json['movement_type'] ?? '',
      qty: double.tryParse('${json['qty'] ?? 0}') ?? 0,
    );
  }
}

class HistoryWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  HistoryWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory HistoryWarehouseOption.fromJson(Map<String, dynamic> json) {
    return HistoryWarehouseOption(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}

class HistoryLocationOption {
  final int idLocation;
  final String locationName;

  HistoryLocationOption({required this.idLocation, required this.locationName});

  factory HistoryLocationOption.fromJson(Map<String, dynamic> json) {
    return HistoryLocationOption(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}

class HistoryProductOption {
  final int idProduct;
  final String productCode;
  final String productName;

  HistoryProductOption({
    required this.idProduct,
    required this.productCode,
    required this.productName,
  });

  factory HistoryProductOption.fromJson(Map<String, dynamic> json) {
    return HistoryProductOption(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
    );
  }
}
