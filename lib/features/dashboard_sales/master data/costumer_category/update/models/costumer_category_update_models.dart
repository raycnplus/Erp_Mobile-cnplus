// lib/features/dashboard_sales/master data/costumer_category/models/costumer_category_update_models.dart

class CustomerCategoryUpdateModel {
  final String customerCategoryName;

  CustomerCategoryUpdateModel({
    required this.customerCategoryName,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_category_name": customerCategoryName,
    };
  }

  factory CustomerCategoryUpdateModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryUpdateModel(
      customerCategoryName: json["customer_category_name"] ?? "",
    );
  }
}