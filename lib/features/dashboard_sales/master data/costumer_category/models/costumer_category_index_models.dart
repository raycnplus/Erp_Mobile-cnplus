class CustomerCategoryModel {
  final int idCustomerCategory;
  final String encryption;
  final String customerCategoryName;
  final String customerCategoryCode;
  final String description;

  CustomerCategoryModel({
    required this.idCustomerCategory,
    required this.encryption,
    required this.customerCategoryName,
    required this.customerCategoryCode,
    required this.description,
  });

  factory CustomerCategoryModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryModel(
      idCustomerCategory: json['id_customer_category'] ?? 0,
      encryption: json['encryption'] ?? '-',
      customerCategoryName: json['customer_category_name'] ?? '-',
      customerCategoryCode: json['customer_category_code'] ?? '-',
      description: json['description'] ?? '-',
    );
  }
}
