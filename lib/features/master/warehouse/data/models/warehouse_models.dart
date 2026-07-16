class WarehousePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  WarehousePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WarehousePaginationMeta.fromJson(Map<String, dynamic> json) {
    return WarehousePaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class WarehouseModel {
  final String encryption;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String? address;
  final String? createdDate;

  WarehouseModel({
    required this.encryption,
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
    this.address,
    this.createdDate,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      encryption: json['encryption'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
      address: json['address'],
      createdDate: json['created_date'],
    );
  }
}

class WarehouseDetailModel {
  final WarehouseData warehouse;
  final String? createdByName;
  final String? updatedByName;

  WarehouseDetailModel({
    required this.warehouse,
    this.createdByName,
    this.updatedByName,
  });

  factory WarehouseDetailModel.fromJson(Map<String, dynamic> json) {
    return WarehouseDetailModel(
      warehouse: WarehouseData.fromJson(json['data']),
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}

class WarehouseData {
  final String encryption;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String? address;
  final num? length;
  final num? width;
  final num? height;
  final num? volume;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  WarehouseData({
    required this.encryption,
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
    this.address,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory WarehouseData.fromJson(Map<String, dynamic> json) {
    return WarehouseData(
      encryption: json['encryption'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
      address: json['address'],
      length: _parseNum(json['length']),
      width: _parseNum(json['width']),
      height: _parseNum(json['height']),
      volume: _parseNum(json['volume']),
      description: json['description'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static num? _parseNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}

class WarehouseFormModel {
  String? encryption;
  String warehouseName;
  String warehouseCode;
  String branch;
  String address;
  num length;
  num width;
  num height;
  num volume;
  String description;
  String? createdDate;
  String? createdByName;
  String? updatedDate;
  String? updatedByName;

  WarehouseFormModel({
    this.encryption,
    this.warehouseName = '',
    this.warehouseCode = '',
    this.branch = '',
    this.address = '',
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.volume = 0,
    this.description = '',
    this.createdDate,
    this.createdByName,
    this.updatedDate,
    this.updatedByName,
  });

  factory WarehouseFormModel.fromDetail(WarehouseDetailModel detail) {
    final w = detail.warehouse;
    return WarehouseFormModel(
      encryption: w.encryption,
      warehouseName: w.warehouseName,
      warehouseCode: w.warehouseCode,
      branch: w.branch ?? '',
      address: w.address ?? '',
      length: w.length ?? 0,
      width: w.width ?? 0,
      height: w.height ?? 0,
      volume: w.volume ?? 0,
      description: w.description ?? '',
      createdDate: w.createdDate,
      createdByName: detail.createdByName,
      updatedDate: w.updatedDate,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() =>
      warehouseName.trim().isNotEmpty && warehouseCode.trim().isNotEmpty;

  String? validateWarehouseName() {
    if (warehouseName.trim().isEmpty) return 'Warehouse name is required';
    return null;
  }

  String? validateWarehouseCode() {
    if (warehouseCode.trim().isEmpty) return 'Warehouse code is required';
    return null;
  }

  Map<String, dynamic> toJson() => {
        'warehouse_name': warehouseName,
        'warehouse_code': warehouseCode,
        'branch': branch.isEmpty ? null : branch,
        'address': address.isEmpty ? null : address,
        'length': length == 0 ? null : length,
        'width': width == 0 ? null : width,
        'height': height == 0 ? null : height,
        'volume': volume == 0 ? null : volume,
        'description': description.isEmpty ? null : description,
      };
}