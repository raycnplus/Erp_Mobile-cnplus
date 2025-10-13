// lib/features/dashboard_sales/master data/costumer_category/models/costumer_category_show_models.dart

class CustomerCategoryShowModel {
  final String idCustomerCategory;
  final String customerCategoryName;
  final String customerCategoryCode;
  final String? createdDate;
  final String? createdBy;

  CustomerCategoryShowModel({
    required this.idCustomerCategory,
    required this.customerCategoryName,
    required this.customerCategoryCode,
    this.createdDate,
    this.createdBy,
  });

  factory CustomerCategoryShowModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryShowModel(
      idCustomerCategory: json['id_customer_category']?.toString() ?? '-',
      customerCategoryName: json['customer_category_name'] ?? '-',
      customerCategoryCode: json['customer_category_code'] ?? '-',
      createdDate: json['created_date'],
      createdBy: json['created_by_name']?.toString(),
    );
  }
}