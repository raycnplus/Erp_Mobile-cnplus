class CustomerIndexModel {
  final int idCustomer;
  final String customerName;
  final String email;
  final String phoneNo;
  final String? city;

  CustomerIndexModel({
    required this.idCustomer,
    required this.customerName,
    required this.email,
    required this.phoneNo,
    this.city,
  });

  factory CustomerIndexModel.fromJson(Map<String, dynamic> json) {
    return CustomerIndexModel(
      idCustomer: json['id_customer'],
      customerName: json['customer_name'] ?? '-',
      email: json['email'] ?? '-',
      phoneNo: json['phone_no'] ?? '-',
      city: json['city'] ?? '-',
    );
  }
}
