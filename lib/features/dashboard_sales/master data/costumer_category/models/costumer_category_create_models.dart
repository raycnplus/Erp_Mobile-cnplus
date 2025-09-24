class CustomerCategoryCreateModel {
  final String customerCategoryCode;
  final String customerCategoryName;
  final String description;

  CustomerCategoryCreateModel({
    required this.customerCategoryCode,
    required this.customerCategoryName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_category_code": customerCategoryCode,
      "customer_category_name": customerCategoryName,
      "description": description,
    };
  }
}
