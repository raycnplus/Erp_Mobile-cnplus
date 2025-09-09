class ProductTypeDetail {
  final int id;
  final String name;
  final String encryption;
  final String? createdDate;
  final String? createdBy;

  ProductTypeDetail({
    required this.id,
    required this.name,
    required this.encryption,
    this.createdDate,
    this.createdBy,
  });

  factory ProductTypeDetail.fromJson(Map<String, dynamic> json) {
    return ProductTypeDetail(
      id: json['id_product_type'] ?? 0,
      name: json['product_type_name'] ?? '',
      encryption: json['encryption'] ?? '',
      createdDate: json['created_date'],
      createdBy: json['created_by']?.toString(), 
    );
  }
}
