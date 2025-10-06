// update_location_models.dart

// Helper function untuk parsing yang aman
int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

String _parseString(dynamic value, {String defaultValue = ''}) {
  return value?.toString() ?? defaultValue;
}


class LocationUpdateModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final int warehouse; // Diubah dari idWarehouse
  final String parentLocationName;
  final int? parentLocation; // Diubah dari parentLocationIdb
  final int height;
  final int length;
  final int width;
  final int volume;
  final String description;

  LocationUpdateModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.warehouse, // Diubah
    required this.parentLocationName,
    this.parentLocation, // Diubah
    required this.height,
    required this.length,
    required this.width,
    required this.volume,
    required this.description,
  });

  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) {
    return LocationUpdateModel(
      idLocation: _parseInt(json['id_location']),
      locationName: _parseString(json['location_name']),
      locationCode: _parseString(json['location_code']),
      warehouseName: _parseString(json['warehouse_name']),
      warehouse: _parseInt(json['warehouse']), // Diubah dari 'id_warehouse'
      parentLocationName: _parseString(json['parent_location_name']),
      parentLocation: json['parent_location'] == null ? null : _parseInt(json['parent_location']), // Diubah dari 'parent_location_id'
      height: _parseInt(json['height']),
      length: _parseInt(json['length']),
      width: _parseInt(json['width']),
      volume: _parseInt(json['volume']),
      description: _parseString(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'location_name': locationName,
      'location_code': locationCode,
      'warehouse_name': warehouseName,
      'warehouse': warehouse, // Diubah
      'parent_location_name': parentLocationName,
      'parent_location': parentLocation, // Diubah
      'height': height,
      'length': length,
      'width': width,
      'volume': volume,
      'description': description,
    };
  }
}

class WarehouseDropdownModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseDropdownModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseDropdownModel.fromJson(Map<String, dynamic> json) {
    return WarehouseDropdownModel(
      idWarehouse: _parseInt(json['id_warehouse']),
      warehouseName: _parseString(json['warehouse_name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_warehouse': idWarehouse, 'warehouse_name': warehouseName};
  }

  @override
  String toString() => warehouseName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseDropdownModel &&
          runtimeType == other.runtimeType &&
          idWarehouse == other.idWarehouse;

  @override
  int get hashCode => idWarehouse.hashCode;
}

class LocationDropdownModel {
  final int idLocation;
  final String locationName;

  LocationDropdownModel({required this.idLocation, required this.locationName});

  factory LocationDropdownModel.fromJson(Map<String, dynamic> json) {
    return LocationDropdownModel(
      idLocation: _parseInt(json['id_location']),
      locationName: _parseString(json['location_name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_location': idLocation, 'location_name': locationName};
  }

  @override
  String toString() => locationName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationDropdownModel &&
          runtimeType == other.runtimeType &&
          idLocation == other.idLocation;

  @override
  int get hashCode => idLocation.hashCode;
}