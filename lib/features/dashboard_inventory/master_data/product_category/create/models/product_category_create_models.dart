class ProductCategoryCreateModel {
  final String productCategoryName;

  ProductCategoryCreateModel({
    required this.productCategoryName,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_category_name": productCategoryName,
    };
  }

  factory ProductCategoryCreateModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryCreateModel(
      productCategoryName: json['product_category_name'] ?? '',
    );
  }
}
