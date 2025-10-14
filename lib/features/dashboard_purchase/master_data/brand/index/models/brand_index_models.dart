class BrandIndexModel {
  final int brandId;
  final String brandName;
  final String? brandCode;
  final String source;

  BrandIndexModel({
    required this.brandId,
    required this.brandName,
    this.brandCode,
    required this.source,
  });

  factory BrandIndexModel.fromJson(Map<String, dynamic> json) {
    return BrandIndexModel(
      brandId: int.parse(json['id_brand'].toString()),
      brandName: json['brand_name'] ?? '',
      brandCode: json['brand_code'],
      source: "Lokal",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_brand": brandId,
      "brand_name": brandName,
      "brand_code": brandCode,
      "source": source,
    };
  }
}
