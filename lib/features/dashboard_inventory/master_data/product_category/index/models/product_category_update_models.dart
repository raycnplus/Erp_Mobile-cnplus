class ProductCategoryUpdateModel {
  final String productCategoryName;

  ProductCategoryUpdateModel({
    required this.productCategoryName,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_category_name": productCategoryName,
    };
  }

  factory ProductCategoryUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryUpdateModel(
      productCategoryName: json["product_category_name"] ?? "",
    );
  }
}
