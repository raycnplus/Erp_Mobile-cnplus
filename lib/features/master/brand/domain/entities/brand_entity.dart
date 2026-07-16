class BrandEntity {
  final int id;
  final String brandName;
  final String brandCode;

  BrandEntity({
    required this.id,
    required this.brandName,
    required this.brandCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrandEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}