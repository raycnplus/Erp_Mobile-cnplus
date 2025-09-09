class ProductTypeDetail {
  final int idProductCategory;
  final String productCategoryName;
  final String? createdDate;
  final String? createdBy;

  ProductTypeDetail({
    required this.idProductCategory,
    required this.productCategoryName,
    this.createdDate,
    this.createdBy,
  });

  factory ProductTypeDetail.fromJson(Map<String, dynamic> json) {
    return ProductTypeDetail(
      idProductCategory: json['id_product_category'],
      productCategoryName: json['product_category_name'] ?? '-',
      createdDate: json['created_date'],
      createdBy: json['created_by'],
    );
  }
}
