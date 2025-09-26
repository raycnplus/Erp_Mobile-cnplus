class WarehouseIndexModel {
  final int id;
  final String encryption;
  final String warehouseName;
  final String warehouseCode;
  final String? branch;
  final String? address;
  final int? length;
  final int? width;
  final int? height;
  final int? volume;
  final String? description;
  final String createdDate;
  final int createdBy;
  final String isDelete;

  WarehouseIndexModel({
    required this.id,
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
    required this.createdDate,
    required this.createdBy,
    required this.isDelete,
  });

  factory WarehouseIndexModel.fromJson(Map<String, dynamic> json) {
    return WarehouseIndexModel(
      // Mengonversi ID secara aman. Bisa menerima angka maupun teks dari API.
      id: int.tryParse(json['id_warehouse'].toString()) ?? 0,
      
      encryption: json['encryption'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      branch: json['branch'],
      address: json['address'],
      length: int.tryParse(json['length'].toString()), // Juga dibuat aman jika null
      width: int.tryParse(json['width'].toString()),
      height: int.tryParse(json['height'].toString()),
      volume: int.tryParse(json['volume'].toString()),
      description: json['description'],
      createdDate: json['created_date'] ?? '',

      // Mengonversi createdBy secara aman.
      createdBy: int.tryParse(json['created_by'].toString()) ?? 0,

      isDelete: json['is_delete'] ?? 'N',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_warehouse': id,
      'encryption': encryption,
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
      'is_delete': isDelete,
    };
  }
}