// create_location_models.dart

class LocationCreateModel {
  final String locationName;
  final String locationCode;
  final int warehouse;
  final int? parentLocation; 
  final double? length;
  final double? width;
  final double? height;
  final double? volume;
  final String? description;

  LocationCreateModel({
    required this.locationName,
    required this.locationCode,
    required this.warehouse,
    this.parentLocation, 
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
      "warehouse": warehouse,
      "parent_location": parentLocation, 
      "length": length?.toInt(),
      "width": width?.toInt(),
      "height": height?.toInt(),
      "volume": volume?.toString(),
      "description": description,
    };
  }
}

// ... sisa kode model dropdown (WarehouseDropdownModel, LocationDropdownModel) tetap sama ...
class WarehouseDropdownModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseDropdownModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseDropdownModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id_warehouse'] ?? json['id'] ?? json['warehouse_id'];
    final id = rawId == null
        ? 0
        : (rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0);
    final name =
        json['warehouse_name'] ??
            json['name'] ??
            json['warehouse_name_display'] ??
            '';
    return WarehouseDropdownModel(idWarehouse: id, warehouseName: name);
  }

  Map<String, dynamic> toJson() {
    return {'id_warehouse': idWarehouse, 'warehouse_name': warehouseName};
  }

  @override
  String toString() => warehouseName;
}

class LocationDropdownModel {
  final int id;
  final String name;

  LocationDropdownModel({required this.id, required this.name});

  factory LocationDropdownModel.fromJson(Map<String, dynamic> json) {
    return LocationDropdownModel(
      id: json['id_location'],
      name: json['location_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_location': id, 'location_name': name};
  }

  @override
  String toString() => name;
}