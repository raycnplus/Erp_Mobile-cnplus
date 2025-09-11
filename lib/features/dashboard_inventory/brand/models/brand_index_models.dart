class BrandIndexModel {
  final int id;
  final String brandName;
  final String? brandCode;
  final String source;

  BrandIndexModel({
    required this.id,
    required this.brandName,
    this.brandCode,
    required this.source,
  });

  factory BrandIndexModel.fromJson(Map<String, dynamic> json) {
    return BrandIndexModel(
      id: json['id_brand'] ?? 0,
      brandName: json['brand_name'] ?? '',
      brandCode: json['brand_code'],
      source: "Lokal",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_brand": id,
      "brand_name": brandName,
      "brand_code": brandCode,
      "source": source,
    };
  }
}
