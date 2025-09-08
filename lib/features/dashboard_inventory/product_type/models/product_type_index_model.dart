class ProductType {
  final int id;
  final String name;
  final String encryption;

  ProductType({
    required this.id,
    required this.name,
    required this.encryption,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id_product_type'] ?? 0,
      name: json['product_type_name'] ?? '',
      encryption: json['encryption'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_product_type": id,
      "product_type_name": name,
      "encryption": encryption,
    };
  }
}
