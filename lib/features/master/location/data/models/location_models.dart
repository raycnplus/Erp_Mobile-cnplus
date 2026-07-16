class LocationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LocationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LocationPaginationMeta.fromJson(Map<String, dynamic> json) {
    return LocationPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class LocationModel {
  final String encryption;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final String parentLocationName;

  LocationModel({
    required this.encryption,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.parentLocationName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      encryption: json['encryption'] ?? '',
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      parentLocationName: json['parent_location_name'] ?? '-',
    );
  }
}

class LocationDetailModel {
  final LocationData location;
  final String? createdByName;
  final String? updatedByName;

  LocationDetailModel({
    required this.location,
    this.createdByName,
    this.updatedByName,
  });

  factory LocationDetailModel.fromJson(Map<String, dynamic> json) {
    return LocationDetailModel(
      location: LocationData.fromJson(json['data']),
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}

class LocationData {
  final String encryption;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final int? warehouse;
  final int? parentLocation;
  final String? parentLocationName;
  final num? length;
  final num? width;
  final num? height;
  final num? volume;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  LocationData({
    required this.encryption,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    this.warehouse,
    this.parentLocation,
    this.parentLocationName,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      encryption: json['encryption'] ?? '',
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      warehouse: _parseInt(json['warehouse']),
      parentLocation: _parseInt(json['parent_location']),
      parentLocationName: json['parent_location_name'],
      length: _parseNum(json['length']),
      width: _parseNum(json['width']),
      height: _parseNum(json['height']),
      volume: _parseNum(json['volume']),
      description: json['description'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static num? _parseNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}

class DropdownWarehouse {
  final int id;
  final String name;
  final String encryption;

  DropdownWarehouse({required this.id, required this.name, required this.encryption});

  factory DropdownWarehouse.fromJson(Map<String, dynamic> json) {
    return DropdownWarehouse(
      id: int.parse((json['id_warehouse'] ?? json['id'] ?? '0').toString()),
      name: json['warehouse_name'] ?? json['name'] ?? '',
      encryption: json['encryption'] ?? '',
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is DropdownWarehouse && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DropdownLocation {
  final int id;
  final String name;
  final String code;
  final String encryption;

  DropdownLocation({
    required this.id,
    required this.name,
    required this.code,
    required this.encryption,
  });

  factory DropdownLocation.fromJson(Map<String, dynamic> json) {
    return DropdownLocation(
      id: int.parse((json['id_location'] ?? json['id'] ?? '0').toString()),
      name: json['location_name'] ?? json['name'] ?? '',
      code: json['location_code'] ?? json['code'] ?? '',
      encryption: json['encryption'] ?? '',
    );
  }

  @override
  String toString() => '$name ($code)';

  @override
  bool operator ==(Object other) =>
      other is DropdownLocation && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class LocationDropdownData {
  final List<DropdownWarehouse> warehouses;
  final List<DropdownLocation> parentLocations;

  LocationDropdownData({
    required this.warehouses,
    required this.parentLocations,
  });

  factory LocationDropdownData.fromJson(Map<String, dynamic> json) {
    final warehouses = (json['warehouses'] as List? ?? [])
        .map((e) => DropdownWarehouse.fromJson(e))
        .toList();
    final locations = (json['locations'] as List? ?? [])
        .map((e) => DropdownLocation.fromJson(e))
        .toList();
    return LocationDropdownData(
      warehouses: warehouses,
      parentLocations: locations,
    );
  }
}

class LocationFormModel {
  String? encryption;
  String locationName;
  String locationCode;
  int? warehouse;
  int? parentLocation;
  num? length;
  num? width;
  num? height;
  num? volume;
  String description;
  String? createdDate;
  String? createdByName;
  String? updatedDate;
  String? updatedByName;

  LocationFormModel({
    this.encryption,
    this.locationName = '',
    this.locationCode = '',
    this.warehouse,
    this.parentLocation,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description = '',
    this.createdDate,
    this.createdByName,
    this.updatedDate,
    this.updatedByName,
  });

  factory LocationFormModel.fromDetail(LocationDetailModel detail) {
    final d = detail.location;
    return LocationFormModel(
      encryption: d.encryption,
      locationName: d.locationName,
      locationCode: d.locationCode,
      warehouse: d.warehouse,
      parentLocation: d.parentLocation,
      length: d.length,
      width: d.width,
      height: d.height,
      volume: d.volume,
      description: d.description ?? '',
      createdDate: d.createdDate,
      createdByName: detail.createdByName,
      updatedDate: d.updatedDate,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() =>
      locationName.trim().isNotEmpty &&
      locationCode.trim().isNotEmpty &&
      warehouse != null;

  String? validateLocationName() {
    if (locationName.trim().isEmpty) return 'Location name is required';
    return null;
  }

  String? validateLocationCode() {
    if (locationCode.trim().isEmpty) return 'Location code is required';
    return null;
  }

  String? validateWarehouse() {
    if (warehouse == null) return 'Warehouse is required';
    return null;
  }

  Map<String, dynamic> toJson() => {
        'location_name': locationName,
        'location_code': locationCode,
        'warehouse': warehouse,
        'parent_location': parentLocation,
        'length': length == 0 ? null : length,
        'width': width == 0 ? null : width,
        'height': height == 0 ? null : height,
        'volume': volume == 0 ? null : volume,
        'description': description.isEmpty ? null : description,
      };
}