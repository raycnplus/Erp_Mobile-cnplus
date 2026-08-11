int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

class StorePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  StorePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class StoreModel {
  final String encryption;
  final String storeName;
  final String address;
  final int warehouse;
  final int location;
  final bool hasActiveSession;

  StoreModel({
    required this.encryption,
    required this.storeName,
    required this.address,
    required this.warehouse,
    required this.location,
    this.hasActiveSession = false,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        encryption: json['encryption']?.toString() ?? '',
        storeName: json['store_name']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        warehouse: _pi(json['warehouse']),
        location: _pi(json['location']),
        hasActiveSession: json['has_active_session'] == true,
      );
}

class StoreDetailModel {
  final StoreData store;
  final bool hasActiveSession;

  StoreDetailModel({required this.store, required this.hasActiveSession});

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StoreDetailModel(
      store: StoreData.fromJson(data is Map<String, dynamic> ? data : {}),
      hasActiveSession:
          (data is Map ? data['has_active_session'] : false) == true,
    );
  }
}

class StoreData {
  final String encryption;
  final String storeName;
  final String address;
  final int warehouse;
  final int location;
  final String? createdByName;
  final String? updatedByName;
  final String? createdDate;
  final String? updatedDate;

  StoreData({
    required this.encryption,
    required this.storeName,
    required this.address,
    required this.warehouse,
    required this.location,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        encryption: json['encryption']?.toString() ?? '',
        storeName: json['store_name']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        warehouse: _pi(json['warehouse']),
        location: _pi(json['location']),
        createdByName: json['created_by_name']?.toString(),
        updatedByName: json['updated_by_name']?.toString(),
        createdDate: json['created_date']?.toString(),
        updatedDate: json['updated_date']?.toString(),
      );
}

class StoreFormOptions {
  final List<StoreOptionItem> warehouses;
  final List<StoreOptionItem> locations;

  StoreFormOptions({required this.warehouses, required this.locations});

  factory StoreFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StoreFormOptions(
      warehouses: (data['warehouses'] as List? ?? [])
          .map((e) => StoreOptionItem.fromWarehouse(e))
          .toList(),
      locations: (data['locations'] as List? ?? [])
          .map((e) => StoreOptionItem.fromLocation(e))
          .toList(),
    );
  }

  static StoreFormOptions empty() =>
      StoreFormOptions(warehouses: [], locations: []);
}

class StoreOptionItem {
  final int id;
  final String name;

  StoreOptionItem({required this.id, required this.name});

  factory StoreOptionItem.fromWarehouse(Map<String, dynamic> json) =>
      StoreOptionItem(
        id: _pi(json['id_warehouse']),
        name: json['warehouse_name']?.toString() ?? '',
      );

  factory StoreOptionItem.fromLocation(Map<String, dynamic> json) =>
      StoreOptionItem(
        id: _pi(json['id_location']),
        name: json['location_name']?.toString() ?? '',
      );

  @override
  bool operator ==(Object o) => o is StoreOptionItem && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class StoreFormModel {
  String? encryption;
  String storeName;
  String address;
  int? warehouseId;
  int? locationId;

  StoreFormModel({
    this.encryption,
    this.storeName = '',
    this.address = '',
    this.warehouseId,
    this.locationId,
  });

  factory StoreFormModel.fromDetail(StoreDetailModel d) => StoreFormModel(
        encryption: d.store.encryption,
        storeName: d.store.storeName,
        address: d.store.address,
        warehouseId: d.store.warehouse == 0 ? null : d.store.warehouse,
        locationId: d.store.location == 0 ? null : d.store.location,
      );

  bool isValid() =>
      storeName.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      warehouseId != null &&
      locationId != null;

  Map<String, dynamic> toJson() => {
        'store_name': storeName,
        'address': address,
        'warehouse': warehouseId,
        'location': locationId,
      };
}