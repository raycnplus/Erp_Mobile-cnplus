class ProductTypeUpdateModel {
  final String productTypeName;

  ProductTypeUpdateModel({
    required this.productTypeName,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_type_name": productTypeName,
    };
  }

  factory ProductTypeUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeUpdateModel(
      productTypeName: json["product_type_name"] ?? "",
    );
  }
}