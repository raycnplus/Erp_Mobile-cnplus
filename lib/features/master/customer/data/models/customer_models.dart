class CustomerPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  CustomerPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CustomerPaginationMeta.fromJson(Map<String, dynamic> json) {
    return CustomerPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class CustomerModel {
  final String encryption;
  final String customerName;
  final String customerCode;
  final String customerType;
  final String? email;
  final String? phoneNo;
  final String? city;
  final String? createdDate;

  CustomerModel({
    required this.encryption,
    required this.customerName,
    required this.customerCode,
    required this.customerType,
    this.email,
    this.phoneNo,
    this.city,
    this.createdDate,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      encryption: json['encryption'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerCode: json['customer_code'] ?? '',
      customerType: json['customer_type'] ?? '',
      email: json['email'],
      phoneNo: json['phone_no'],
      city: json['city'],
      createdDate: json['created_date'],
    );
  }
}

class CustomerDetailModel {
  final CustomerData customer;
  final String? createdByName;
  final String? updatedByName;

  CustomerDetailModel({
    required this.customer,
    this.createdByName,
    this.updatedByName,
  });

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CustomerDetailModel(
      customer: CustomerData.fromJson(data),
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class CustomerData {
  final String encryption;
  final String customerName;
  final String customerCode;
  final String customerType;
  final int? customerCategory;
  final String? email;
  final String? phoneNo;
  final String? country;
  final String? province;
  final String? city;
  final String? address;
  final String? postalCode;
  final String? website;
  final String? picName;
  final String? picPhone;
  final String? picEmail;
  final String? npwp;
  final bool isVatRegistered;
  final int? priceList;
  final String? createdDate;
  final String? updatedDate;

  CustomerData({
    required this.encryption,
    required this.customerName,
    required this.customerCode,
    required this.customerType,
    this.customerCategory,
    this.email,
    this.phoneNo,
    this.country,
    this.province,
    this.city,
    this.address,
    this.postalCode,
    this.website,
    this.picName,
    this.picPhone,
    this.picEmail,
    this.npwp,
    this.isVatRegistered = false,
    this.priceList,
    this.createdDate,
    this.updatedDate,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      encryption: json['encryption'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerCode: json['customer_code'] ?? '',
      customerType: json['customer_type'] ?? '',
      customerCategory: _parseInt(json['customer_category']),
      email: json['email'],
      phoneNo: json['phone_no'],
      country: json['country'],
      province: json['province'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postal_code'],
      website: json['website'],
      picName: json['pic_name'],
      picPhone: json['pic_phone'],
      picEmail: json['pic_email'],
      npwp: json['npwp'],
      isVatRegistered:
          json['is_vat_registered'] == 1 || json['is_vat_registered'] == true,
      priceList: _parseInt(json['price_list']),
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class CustomerDropdownData {
  final List<CustomerCategoryDropdown> categories;
  final List<CountryDropdown> countries;
  final List<PriceListDropdown> priceLists;

  CustomerDropdownData({
    required this.categories,
    required this.countries,
    required this.priceLists,
  });

  factory CustomerDropdownData.fromJson(Map<String, dynamic> json) {
    return CustomerDropdownData(
      categories: (json['customer_categories'] as List? ?? [])
          .map((e) => CustomerCategoryDropdown.fromJson(e))
          .toList(),
      countries: (json['countries'] as List? ?? [])
          .map((e) => CountryDropdown.fromJson(e))
          .toList(),
      priceLists: (json['price_lists'] as List? ?? [])
          .map((e) => PriceListDropdown.fromJson(e))
          .toList(),
    );
  }
}

class CustomerCategoryDropdown {
  final int id;
  final String name;
  CustomerCategoryDropdown({required this.id, required this.name});

  factory CustomerCategoryDropdown.fromJson(Map<String, dynamic> json) =>
      CustomerCategoryDropdown(
        id: int.parse((json['id_customer_category'] ?? '0').toString()),
        name: json['customer_category_name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is CustomerCategoryDropdown && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class CountryDropdown {
  final int id;
  final String name;
  CountryDropdown({required this.id, required this.name});

  factory CountryDropdown.fromJson(Map<String, dynamic> json) =>
      CountryDropdown(
        id: int.parse((json['id_country'] ?? '0').toString()),
        name: json['name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is CountryDropdown && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PriceListDropdown {
  final int id;
  final String name;
  PriceListDropdown({required this.id, required this.name});

  factory PriceListDropdown.fromJson(Map<String, dynamic> json) =>
      PriceListDropdown(
        id: int.parse((json['id_price_list'] ?? '0').toString()),
        name: json['price_list_name'] ?? json['name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is PriceListDropdown && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class CustomerTypeOption {
  final String value;
  final String displayName;
  CustomerTypeOption({required this.value, required this.displayName});

  static List<CustomerTypeOption> get types => [
        CustomerTypeOption(value: 'person', displayName: 'Person'),
        CustomerTypeOption(value: 'company', displayName: 'Company'),
      ];

  @override
  String toString() => displayName;

  @override
  bool operator ==(Object other) =>
      other is CustomerTypeOption && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class CustomerFormModel {
  String? encryption;
  String customerName;
  String customerCode;
  String? customerType;
  int? customerCategory;
  String? email;
  String? phoneNo;
  String? country;
  String? province;
  String? city;
  String? address;
  String? postalCode;
  String? website;
  String? picName;
  String? picPhone;
  String? picEmail;
  String? npwp;
  bool isVatRegistered;
  int? priceList;
  String? createdDate;
  String? createdByName;
  String? updatedDate;
  String? updatedByName;

  CustomerFormModel({
    this.encryption,
    this.customerName = '',
    this.customerCode = '',
    this.customerType,
    this.customerCategory,
    this.email,
    this.phoneNo,
    this.country,
    this.province,
    this.city,
    this.address,
    this.postalCode,
    this.website,
    this.picName,
    this.picPhone,
    this.picEmail,
    this.npwp,
    this.isVatRegistered = false,
    this.priceList,
    this.createdDate,
    this.createdByName,
    this.updatedDate,
    this.updatedByName,
  });

  factory CustomerFormModel.fromDetail(CustomerDetailModel detail) {
    final c = detail.customer;
    return CustomerFormModel(
      encryption: c.encryption,
      customerName: c.customerName,
      customerCode: c.customerCode,
      customerType: c.customerType,
      customerCategory: c.customerCategory,
      email: c.email,
      phoneNo: c.phoneNo,
      country: c.country, 
      province: c.province,
      city: c.city,
      address: c.address,
      postalCode: c.postalCode,
      website: c.website,
      picName: c.picName,
      picPhone: c.picPhone,
      picEmail: c.picEmail,
      npwp: c.npwp,
      isVatRegistered: c.isVatRegistered,
      priceList: c.priceList,
      createdDate: c.createdDate,
      createdByName: detail.createdByName,
      updatedDate: c.updatedDate,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() =>
      customerName.trim().isNotEmpty &&
      customerCode.trim().isNotEmpty &&
      customerType != null &&
      customerCategory != null &&
      (email?.trim().isNotEmpty ?? false);

  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'customer_code': customerCode,
        'customer_type': customerType,
        'customer_category': customerCategory,
        'email': email,
        'phone_no': phoneNo?.isEmpty == true ? null : phoneNo,
        'country': country?.isEmpty == true ? null : country,
        'province': province?.isEmpty == true ? null : province,
        'city': city?.isEmpty == true ? null : city,
        'address': address?.isEmpty == true ? null : address,
        'postal_code': postalCode?.isEmpty == true ? null : postalCode,
        'website': website?.isEmpty == true ? null : website,
        'pic_name': picName?.isEmpty == true ? null : picName,
        'pic_phone': picPhone?.isEmpty == true ? null : picPhone,
        'pic_email': picEmail?.isEmpty == true ? null : picEmail,
        'npwp': npwp?.isEmpty == true ? null : npwp,
        'is_vat_registered': isVatRegistered ? 1 : 0,
        'price_list': priceList,
      };
}