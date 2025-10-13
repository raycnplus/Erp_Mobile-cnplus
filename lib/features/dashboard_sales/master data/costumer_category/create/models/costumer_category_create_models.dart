
class CustomerCategoryCreateModel {
  final String customerCategoryName;
  final String customerCategoryCode; 
  final String? description;

  CustomerCategoryCreateModel({
    required this.customerCategoryName,
    required this.customerCategoryCode, 
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_category_name": customerCategoryName,
      "customer_category_code": customerCategoryCode, 
      "description": description ?? "",
    };
  }
}