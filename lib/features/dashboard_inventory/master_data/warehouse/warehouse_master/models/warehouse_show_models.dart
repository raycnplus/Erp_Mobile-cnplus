class WarehouseShowModel {
  final int idWarehouse;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String? address;
  final int? length;
  final int? width;
  final int? height;
  final int? volume;
  final String? description;
  final String? createdDate;
  final int? createdBy;

  WarehouseShowModel({
    required this.idWarehouse,
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
    this.createdBy,
  });

  factory WarehouseShowModel.fromJson(Map<String, dynamic> json) {
    return WarehouseShowModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
      address: json['address'],
      length: json['length'],
      width: json['width'],
      height: json['height'],
      volume: json['volume'],
      description: json['description'],
      createdDate: json['created_date'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_warehouse': idWarehouse,
      'warehouse_name': warehouseName,
      'warehouse_code': warehouseCode,
      'branch': branch,
      'address': address,
      'length': length,
      'width': width,
      'height': height,
      'volume': volume,
      'description': description,
      'created_date': createdDate,
      'created_by': createdBy,
    };
  }
}
