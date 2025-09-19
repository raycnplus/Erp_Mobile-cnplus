class LocationShowModel {
  final int idLocation;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final String parentLocationName;
  final String? length;
  final String? width;
  final String? height;
  final String? volume;
  final String? description;
  final String? createdOn;
  final String? createdBy;

  LocationShowModel({
    required this.idLocation,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.parentLocationName,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.description,
    this.createdOn,
    this.createdBy,
  });

  factory LocationShowModel.fromJson(Map<String, dynamic> json) {
    return LocationShowModel(
      idLocation: json['id_location'],
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      parentLocationName: json['parent_location_name'] ?? '',
      length: json['length']?.toString(),
      width: json['width']?.toString(),
      height: json['height']?.toString(),
      volume: json['volume']?.toString(),
      description: json['description'],
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }
}
