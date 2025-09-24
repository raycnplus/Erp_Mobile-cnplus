
class ProductCategory {
  final int id;
  final String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id_product_category'] ?? 0,
      name: json['product_category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_product_category': id,
      'product_category_name': name,
    };
  }
}