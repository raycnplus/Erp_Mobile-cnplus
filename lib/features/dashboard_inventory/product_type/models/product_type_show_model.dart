class ProductTypeShowModel {
  final String idProductType;
  final String productTypeName;
  final String? createdDate;
  final String? createdBy;

  ProductTypeShowModel({
    required this.idProductType,
    required this.productTypeName,
    this.createdDate,
    this.createdBy,
  });

  factory ProductTypeShowModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeShowModel(
      idProductType: json['id_product_type']?.toString() ?? '-',
      productTypeName: json['product_type_name'] ?? '-',
      createdDate: json['created_date'],
      createdBy: json['created_by']?.toString(), // bisa angka / string
    );
  }
}
