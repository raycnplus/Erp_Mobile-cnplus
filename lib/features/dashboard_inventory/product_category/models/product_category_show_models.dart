class ProductCategoryShowModels {
  final int id;
  final String productCategoryName;
  final String createdOn;
  final String? createdBy;

  ProductCategoryShowModels({
    required this.id,
    required this.productCategoryName,
    required this.createdOn,
    this.createdBy,
  });

  factory ProductCategoryShowModels.fromJson(Map<String, dynamic> json) {
    return ProductCategoryShowModels(
      id: int.parse(json['id_product_category'].toString()),
      productCategoryName: json['product_category_name'],
      createdOn: json['created_date'],
      createdBy:json['created_by']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_product_category': id,
      'product_category_name': productCategoryName,
      'created_date': createdOn,
      'created_by': createdBy,
    };
  }
}
