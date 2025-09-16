class WarehouseIndexModel {
  final String warehouseName;
  final String warehouseCode;
  final String? branch;

  WarehouseIndexModel({
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
  });

  factory WarehouseIndexModel.fromJson(Map<String, dynamic> json) {
    return WarehouseIndexModel(
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_name': warehouseName,
      'warehouse_code': warehouseCode,
      'branch': branch,
    };
  }
}
