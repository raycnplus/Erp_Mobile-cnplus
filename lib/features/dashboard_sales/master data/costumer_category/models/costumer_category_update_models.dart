class CustomerCategoryUpdateModel {
  final int idCustomerCategory;
  final String customerCategoryCode;
  final String customerCategoryName;
  final String description;

  CustomerCategoryUpdateModel({
    required this.idCustomerCategory,
    required this.customerCategoryCode,
    required this.customerCategoryName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_customer_category": idCustomerCategory,
      "customer_category_code": customerCategoryCode,
      "customer_category_name": customerCategoryName,
      "description": description,
    };
  }
}
