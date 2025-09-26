class WarehouseCreateModel {
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String? address;
  final int? length;
  final int? width;
  final int? height;
  final int? volume;
  final String? description;

  WarehouseCreateModel({
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
    this.address,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'warehouse_name': warehouseName,
      'warehouse_code': warehouseCode,
      'branch': branch,
      'address': address,
      'length': length,
      'width': width,
      'height': height,
      'volume': volume,
      'description': description,
    };
  }
}
