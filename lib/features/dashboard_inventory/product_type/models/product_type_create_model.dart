class ProductTypeCreateModel {
  final String productTypeName;

  ProductTypeCreateModel({
    required this.productTypeName,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_type_name": productTypeName,
    };
  }

  factory ProductTypeCreateModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeCreateModel(
      productTypeName: json['product_type_name'],
    );
  }
}
