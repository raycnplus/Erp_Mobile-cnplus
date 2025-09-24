// create_location_models.dart

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

  // ▼▼▼ FUNGSI INI TELAH DIPERBAIKI LAGI ▼▼▼
  Map<String, dynamic> toJson() {
    return {
      "location_name": locationName,
      "location_code": locationCode,
      "warehouse_id": warehouseId,
      "parent_location_id": parentLocationId,

      // PERBAIKAN: Konversi ke integer untuk field dimensi
      "length": length?.toInt(),
      "width": width?.toInt(),
      "height": height?.toInt(),

      // Biarkan volume sebagai string sesuai error sebelumnya
      "volume": volume?.toString(),

      "description": description,
    };
  }
}

// Model for dropdowns (tidak ada perubahan di sini)
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