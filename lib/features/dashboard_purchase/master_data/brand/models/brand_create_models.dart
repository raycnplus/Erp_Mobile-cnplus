class BrandCreateModel {
  final String brandName;
  final String brandCode;

  BrandCreateModel({
    required this.brandName,
    required this.brandCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "brand_name": brandName,
      "brand_code": brandCode,
    };
  }
}
