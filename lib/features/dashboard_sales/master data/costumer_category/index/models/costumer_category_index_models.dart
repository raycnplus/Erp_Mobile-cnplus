// lib/features/dashboard_sales/master data/costumer_category/models/costumer_category_index_models.dart

class CustomerCategoryModel {
  final int id;
  final String name;
  final String createdDate;

  CustomerCategoryModel({
    required this.id,
    required this.name,
    required this.createdDate,
  });

  factory CustomerCategoryModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryModel(
      id: json['id_customer_category'] ?? 0,
      name: json['customer_category_name'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}