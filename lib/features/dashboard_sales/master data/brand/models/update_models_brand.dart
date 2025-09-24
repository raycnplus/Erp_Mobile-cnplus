class BrandUpdateModel {
  final int idBrand;
  final String brandName;
  final String brandCode;

  BrandUpdateModel({
    required this.idBrand,
    required this.brandName,
    required this.brandCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_brand': idBrand,
      'brand_name': brandName,
      'brand_code': brandCode,
    };
  }

  factory BrandUpdateModel.fromJson(Map<String, dynamic> json) {
    return BrandUpdateModel(
      idBrand: json['id_brand'],
      brandName: json['brand_name'],
      brandCode: json['brand_code'],
    );
  }
}
