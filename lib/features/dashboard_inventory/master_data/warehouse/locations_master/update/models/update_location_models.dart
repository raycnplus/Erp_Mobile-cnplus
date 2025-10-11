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
  final int idWarehouse; // <-- Diubah dari 'warehouse'
  final String parentLocationName;
  final int? idParentLocation; // <-- Diubah dari 'parentLocation'
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
    required this.idWarehouse, // <-- Diubah
    required this.parentLocationName,
    this.idParentLocation, // <-- Diubah
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
      idWarehouse: _parseInt(json['id_warehouse']), // <-- Diubah dari 'warehouse'
      parentLocationName: _parseString(json['parent_location_name']),
      idParentLocation: json['id_parent_location'] == null ? null : _parseInt(json['id_parent_location']), // <-- Diubah dari 'parent_location'
      height: _parseInt(json['height']),
      length: _parseInt(json['length']),
      width: _parseInt(json['width']),
      volume: _parseInt(json['volume']),
      description: _parseString(json['description']),
    );
  }

  // ... sisa class (toJson) tidak perlu diubah karena tidak dipakai di sini ...
}

class WarehouseDropdownModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseDropdownModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseDropdownModel.fromJson(Map<String, dynamic> json) {
    final id = _parseInt(json['id_warehouse'] ?? json['id']);
    return WarehouseDropdownModel(
      idWarehouse: id,
      warehouseName: _parseString(json['warehouse_name']),
    );
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
    final id = _parseInt(json['id_location'] ?? json['id']);
    return LocationDropdownModel(
      idLocation: id,
      locationName: _parseString(json['location_name']),
    );
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