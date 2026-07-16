class LocationEntity {
  final int id;
  final String name;
  final String code;
  final String warehouseName;
  final String parentLocationName;

  LocationEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.warehouseName,
    required this.parentLocationName,
  });
}