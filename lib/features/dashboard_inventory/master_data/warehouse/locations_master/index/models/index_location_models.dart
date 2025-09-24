class LocationIndexModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final String parentLocationName;

  LocationIndexModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.parentLocationName,
  });

  factory LocationIndexModel.fromJson(Map<String, dynamic> json) {
    return LocationIndexModel(
      idLocation: json['id_location'],
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      parentLocationName: json['parent_location_name'] ?? '',
    );
  }
}
