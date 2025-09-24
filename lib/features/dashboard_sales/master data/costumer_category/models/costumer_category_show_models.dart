class CustomerCategoryShowModel {
  final int idCustomerCategory;
  final String customerCategoryName;
  final String customerCategoryCode;
  final String description;
  final String createdDate;
  final String createdBy;

  CustomerCategoryShowModel({
    required this.idCustomerCategory,
    required this.customerCategoryName,
    required this.customerCategoryCode,
    required this.description,
    required this.createdDate,
    required this.createdBy,
  });

  factory CustomerCategoryShowModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryShowModel(
      idCustomerCategory: json['id_customer_category'] ?? 0,
      customerCategoryName: json['customer_category_name'] ?? '-',
      customerCategoryCode: json['customer_category_code'] ?? '-',
      description: json['description'] ?? '-',
      createdDate: json['created_date'] ?? '-',
      createdBy: json['created_by_name'] ?? '-',
    );
  }
}
