class BrandShowModel {
  final int brandId;
  final String brandName;
  final String brandCode;
  final String? createdDate;
  final String? updatedDate;

  BrandShowModel({
    required this.brandId,
    required this.brandName,
    required this.brandCode,
    this.createdDate,
    this.updatedDate,
  });

  factory BrandShowModel.fromJson(Map<String, dynamic> json) {
    return BrandShowModel(
     brandId: int.parse(json['id_brand'].toString()),
      brandName: json['brand_name'] as String,
      brandCode: json['brand_code'] as String,
      createdDate: json['created_date'] as String?,
      updatedDate: json['updated_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_brand" : brandId,
      "brand_name": brandName,
      "brand_code": brandCode,
      "created_date": createdDate,
      "updated_date": updatedDate,
    };
  }
}

