class LocationCreateModel {
  final String locationName;
  final String locationCode;
  final int warehouseId;
  final int? parentLocationId;
  final double? length;
  final double? width;
  final double? height;
  final double? volume;
  final String? description;

  LocationCreateModel({
    required this.locationName,
    required this.locationCode,
    required this.warehouseId,
    this.parentLocationId,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "location_name": locationName,
      "location_code": locationCode,
      "warehouse_id": warehouseId,
      "parent_location_id": parentLocationId,
      "length": length,
      "width": width,
      "height": height,
      "volume": volume,
      "description": description,
    };
  }
}

// Model for dropdowns
class WarehouseDropdownModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseDropdownModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseDropdownModel.fromJson(Map<String, dynamic> json) {
    return WarehouseDropdownModel(
      idWarehouse: json['id_warehouse'],
      warehouseName: json['warehouse_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_warehouse': idWarehouse,
      'warehouse_name': warehouseName,
    };
  }

  @override
  String toString() => warehouseName; 
}

class LocationDropdownModel {
  final int id;
  final String name;

  LocationDropdownModel({
    required this.id,
    required this.name,
  });

  factory LocationDropdownModel.fromJson(Map<String, dynamic> json) {
    return LocationDropdownModel(
      id: json['id_location'], 
      name: json['location_name'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': id,
      'location_name': name,
    };
  }

  @override
  String toString() => name;
}
