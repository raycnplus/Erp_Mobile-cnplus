class StockMovementPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  StockMovementPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory StockMovementPaginationMeta.fromJson(Map<String, dynamic> json) {
    return StockMovementPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class StockMovementModel {
  final int idStockMovement;
  final String referenceType;
  final int referenceId;
  final String referenceNo;
  final int idProduct;
  final String productName;
  final String productCode;
  final String? locationName;
  final String? warehouseName;
  final double qty;
  final String movementType; // 'in' | 'out'
  final String movementDate;
  final String? notes;

  StockMovementModel({
    required this.idStockMovement,
    required this.referenceType,
    required this.referenceId,
    required this.referenceNo,
    required this.idProduct,
    required this.productName,
    required this.productCode,
    this.locationName,
    this.warehouseName,
    required this.qty,
    required this.movementType,
    required this.movementDate,
    this.notes,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      idStockMovement: json['id_stock_movement'] ?? 0,
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'] ?? 0,
      referenceNo: json['reference_no'] ?? '-',
      idProduct: json['id_product'] ?? 0,
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      locationName: json['location_name'],
      warehouseName: json['warehouse_name'],
      qty: double.tryParse('${json['qty'] ?? 0}') ?? 0,
      movementType: json['movement_type'] ?? '',
      movementDate:
          json['movement_date_formatted'] ?? json['movement_date'] ?? '',
      notes: json['notes'],
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

class LocationOptionModel {
  final int idLocation;
  final String locationName;

  LocationOptionModel({required this.idLocation, required this.locationName});

  factory LocationOptionModel.fromJson(Map<String, dynamic> json) {
    return LocationOptionModel(
      idLocation: json['id_location'] ?? 0,
      locationName: json['location_name'] ?? '',
    );
  }
}

class StockMovementFormOptions {
  final List<WarehouseOptionModel> warehouses;
  final List<String> movementTypes;
  final List<String> referenceTypes;

  StockMovementFormOptions({
    required this.warehouses,
    required this.movementTypes,
    required this.referenceTypes,
  });

  factory StockMovementFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StockMovementFormOptions(
      warehouses: ((data['warehouses'] ?? []) as List)
          .map((e) => WarehouseOptionModel.fromJson(e))
          .toList(),
      movementTypes: ((data['movement_types'] ?? []) as List)
          .map((e) => '$e')
          .toList(),
      referenceTypes: ((data['reference_types'] ?? []) as List)
          .map((e) => '$e')
          .toList(),
    );
  }
}
