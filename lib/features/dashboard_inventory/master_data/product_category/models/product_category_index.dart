class ProductCategory {
  final int id;
  final String name;
  final String source;

  ProductCategory({
    required this.id,
    required this.name,
    required this.source,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id_product_category'] ?? 0,
      name: json['product_category_name'] ?? '',
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_product_category': id,
      'product_category_name': name,
      'source': source,
    };
  }
}
