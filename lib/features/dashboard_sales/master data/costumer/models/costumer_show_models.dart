class CustomerShowModel {
  final int id;
  final String customerName;
  final String customerCode;
  final String customerType;
  final String? customerCategory;
  final String? phoneNo;
  final String? email;
  final String? country;
  final String? province;
  final String? city;
  final String? address;
  final String? postalCode;
  final String? website;
  final String? picName;
  final String? picPhone;
  final String? picEmail;
  final String? createdBy;
  final String createdDate;

  CustomerShowModel({
    required this.id,
    required this.customerName,
    required this.customerCode,
    required this.customerType,
    this.customerCategory,
    this.phoneNo,
    this.email,
    this.country,
    this.province,
    this.city,
    this.address,
    this.postalCode,
    this.website,
    this.picName,
    this.picPhone,
    this.picEmail,
    this.createdBy,
    required this.createdDate,
  });

  factory CustomerShowModel.fromJson(Map<String, dynamic> json) {
    return CustomerShowModel(
      id: json['id_customer'],
      customerName: json['customer_name'] ?? "-",
      customerCode: json['customer_code'] ?? "-",
      customerType: json['customer_type'] ?? "-",
      customerCategory: json['customer_category']?.toString(),
      phoneNo: json['phone_no'],
      email: json['email'],
      country: json['country'],
      province: json['province'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postal_code'],
      website: json['website'],
      picName: json['pic_name'],
      picPhone: json['pic_phone'],
      picEmail: json['pic_email'],
      createdBy: json['created_by']?.toString(),
      createdDate: json['created_date'] ?? "-",
    );
  }
}
