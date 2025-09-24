class LocationUpdateModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final int idWarehouse;
  final String parentLocationName;
  final int? parentLocationId;
  final int height;
  final int length;
  final int width;
  final String volume;
  final String description;

  LocationUpdateModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.parentLocationId,
    required this.warehouseName,
    required this.idWarehouse,
    required this.parentLocationName,
    required this.height,
    required this.length,
    required this.width,
    required this.volume,
    required this.description,
  });

  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) {
    return LocationUpdateModel(
      idLocation: json['id_location'],
      locationName: json['location_name'],
      locationCode: json['location_code'],
      warehouseName: json['warehouse_name'] ?? '',
      idWarehouse: json['id_warehouse'] != null
          ? int.parse(json['id_warehouse'].toString())
          : 0,
      parentLocationName: json['parent_location_name'] ?? '',
      parentLocationId: json['parent_location_id'] != null
          ? int.parse(json['parent_location_id'].toString())
          : null,
      height: json['height'] != null ? int.parse(json['height'].toString()) : 0,
      length: json['length'] != null ? int.parse(json['length'].toString()) : 0,
      width: json['width'] != null ? int.parse(json['width'].toString()) : 0,
      volume: json['volume']?.toString() ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'location_name': locationName,
      'location_code': locationCode,
      'warehouse_name': warehouseName,
      'id_warehouse': idWarehouse,
      'parent_location_name': parentLocationName,
      'parent_location_id': parentLocationId,
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
      idWarehouse: json['id_warehouse'],
      warehouseName: json['warehouse_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_warehouse': idWarehouse, 'warehouse_name': warehouseName};
  }

  @override
  String toString() => warehouseName;
}

class LocationDropdownModel {
  final int idLocation;
  final String locationName;

  LocationDropdownModel({required this.idLocation, required this.locationName});

  factory LocationDropdownModel.fromJson(Map<String, dynamic> json) {
    return LocationDropdownModel(
      idLocation: json['id_location'],
      locationName: json['location_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_location': idLocation, 'location_name': locationName};
  }

  @override
  String toString() => locationName;
}
