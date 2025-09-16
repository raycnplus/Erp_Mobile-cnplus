class WarehouseIndexModel {
  final int id;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;

  WarehouseIndexModel({
    required this.id,
    required this.warehouseName,
    required this.warehouseCode,
    this.branch,
  });

  factory WarehouseIndexModel.fromJson(Map<String, dynamic> json) {
    return WarehouseIndexModel(
      id: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_warehouse': id,
      'warehouse_name': warehouseName,
      'warehouse_code': warehouseCode,
      'branch': branch,
    };
  }
}
