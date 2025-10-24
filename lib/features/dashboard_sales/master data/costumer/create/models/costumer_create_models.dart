// costumer_create_models.dart

class CustomerCreateModel {
  final int idCustomer;
  final String encryption;
  final String customerType;
  final String customerName;
  final String customerCode;
  final int customerCategory;
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
  final String isDelete;
  final int createdBy;
  final String createdDate;
  final int updatedBy;
  final String updatedDate;
  final int? deletedBy;
  final String? deletedDate;

  CustomerCreateModel({
    required this.idCustomer,
    required this.encryption,
    required this.customerType,
    required this.customerName,
    required this.customerCode,
    required this.customerCategory,
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
    required this.isDelete,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    this.deletedBy,
    this.deletedDate,
  });

  factory CustomerCreateModel.fromJson(Map<String, dynamic> json) {
    return CustomerCreateModel(
      idCustomer: json["id_customer"] is int
          ? json["id_customer"]
          : int.tryParse(json["id_customer"].toString()) ?? 0,
      encryption: json["encryption"]?.toString() ?? "",
      customerType: json["customer_type"]?.toString() ?? "",
      customerName: json["customer_name"]?.toString() ?? "",
      customerCode: json["customer_code"]?.toString() ?? "",
      customerCategory: json["customer_category"] is int
          ? json["customer_category"]
          : int.tryParse(json["customer_category"].toString()) ?? 0,
      phoneNo: json["phone_no"]?.toString(),
      email: json["email"]?.toString(),
      country: json["country"]?.toString(),
      province: json["province"]?.toString(),
      city: json["city"]?.toString(),
      address: json["address"]?.toString(),
      postalCode: json["postal_code"]?.toString(),
      website: json["website"]?.toString(),
      picName: json["pic_name"]?.toString(),
      picPhone: json["pic_phone"]?.toString(),
      picEmail: json["pic_email"]?.toString(),
      isDelete: json["is_delete"]?.toString() ?? "0",
      createdBy: json["created_by"] is int
          ? json["created_by"]
          : int.tryParse(json["created_by"].toString()) ?? 0,
      createdDate: json["created_date"]?.toString() ?? "",
      updatedBy: json["updated_by"] is int
          ? json["updated_by"]
          : int.tryParse(json["updated_by"].toString()) ?? 0,
      updatedDate: json["updated_date"]?.toString() ?? "",
      deletedBy: json["deleted_by"] == null
          ? null
          : (json["deleted_by"] is int
                ? json["deleted_by"]
                : int.tryParse(json["deleted_by"].toString())),
      deletedDate: json["deleted_date"]?.toString(),
    );
  }
}

// ▼▼▼ Dropdown Models ▼▼▼

class CustomerCategoryDropdownModel {
  final int idCategory;
  final String categoryName;

  CustomerCategoryDropdownModel({
    required this.idCategory,
    required this.categoryName,
  });

  factory CustomerCategoryDropdownModel.fromJson(Map<String, dynamic> json) {
    final rawId =
        json['id_customer_category'] ?? json['id'] ?? json['category_id'];
    final id = rawId == null
        ? 0
        : (rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0);
    final name =
        json['customer_category_name'] ??
        json['name'] ??
        json['category'] ??
        "-";
    return CustomerCategoryDropdownModel(
      idCategory: id,
      categoryName: name.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id_customer_category": idCategory,
    "customer_category_name": categoryName,
  };

  @override
  String toString() => categoryName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerCategoryDropdownModel &&
          runtimeType == other.runtimeType &&
          idCategory == other.idCategory;

  @override
  int get hashCode => idCategory.hashCode;
}

class CustomerTypeDropdownModel {
  final String value;
  final String displayName;

  CustomerTypeDropdownModel({required this.value, required this.displayName});

  // [DIPERBAIKI] Menggunakan 'static final' agar list tidak dibuat berulang kali. Ini memperbaiki masalah ANR.
  static List<CustomerTypeDropdownModel> get types => [
        CustomerTypeDropdownModel(value: "person", displayName: "Person"),
        CustomerTypeDropdownModel(value: "company", displayName: "Company"),
      ];

  @override
  String toString() => displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerTypeDropdownModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class CountryModel {
  final int id;
  final String name;

  CountryModel({required this.id, required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // [DIPERBAIKI] Parsing ID dibuat lebih aman untuk menangani nilai String dari API. Ini memperbaiki error type 'String'.
    final rawId = json['id_country'];
    final id = rawId == null
        ? 0
        : (rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0);

    return CountryModel(id: id, name: json['name'] ?? 'Unknown Country');
  }

  // [DITAMBAHKAN] Menambahkan operator == dan hashCode untuk praktik terbaik dan stabilitas widget.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
