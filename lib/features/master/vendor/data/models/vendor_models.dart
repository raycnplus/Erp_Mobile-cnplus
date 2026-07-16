class VendorPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  VendorPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory VendorPaginationMeta.fromJson(Map<String, dynamic> json) {
    return VendorPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class VendorModel {
  final String encryption;
  final String vendorCode;
  final String vendorName;
  final String? email;
  final String? contactPersonName;
  final String? city;
  final String? createdDate;

  VendorModel({
    required this.encryption,
    required this.vendorCode,
    required this.vendorName,
    this.email,
    this.contactPersonName,
    this.city,
    this.createdDate,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      encryption: json['encryption'] ?? '',
      vendorCode: json['vendor_code'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      email: json['email'],
      contactPersonName: json['contact_person_name'],
      city: json['city'],
      createdDate: json['created_date'],
    );
  }
}

class VendorDetailModel {
  final VendorData vendor;
  final String? createdByName;
  final String? updatedByName;

  VendorDetailModel({
    required this.vendor,
    this.createdByName,
    this.updatedByName,
  });

  factory VendorDetailModel.fromJson(Map<String, dynamic> json) {
    return VendorDetailModel(
      vendor: VendorData.fromJson(json['data']),
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}

class VendorData {
  final String encryption;
  final String vendorCode;
  final String vendorName;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final int? country;
  final String? countryName;
  final String? phoneNo;
  final String? email;
  final String? npwpNumber;
  final String? contactPersonName;
  final String? contactPersonPhone;
  final String? contactPersonEmail;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final int? currency;
  final String? currencyName;
  final String? createdDate;
  final String? updatedDate;

  VendorData({
    required this.encryption,
    required this.vendorCode,
    required this.vendorName,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.country,
    this.countryName,
    this.phoneNo,
    this.email,
    this.npwpNumber,
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    this.currency,
    this.currencyName,
    this.createdDate,
    this.updatedDate,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      encryption: json['encryption'] ?? '',
      vendorCode: json['vendor_code'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      address: json['address'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code']?.toString(),
      country: _parseInt(json['country']),
      countryName: json['country_name'],
      phoneNo: json['phone_no'],
      email: json['email'],
      npwpNumber: json['npwp_number'],
      contactPersonName: json['contact_person_name'],
      contactPersonPhone: json['contact_person_phone'],
      contactPersonEmail: json['contact_person_email'],
      bankName: json['bank_name'],
      bankAccountNumber: json['bank_account_number'],
      bankAccountName: json['bank_account_name'],
      currency: _parseInt(json['currency']),
      currencyName: json['currency_name'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class CountryModel {
  final int id;
  final String name;
  CountryModel({required this.id, required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      CountryModel(
        id: int.parse(json['id_country'].toString()),
        name: json['name'] ?? '',
      );

  @override
  String toString() => name;
}

class CurrencyModel {
  final int id;
  final String name;
  CurrencyModel({required this.id, required this.name});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      CurrencyModel(
        id: int.parse(json['id'].toString()),
        name: json['currency_name'] ?? '',
      );

  @override
  String toString() => name;
}

class VendorFormModel {
  String? encryption;
  String? vendorName;
  String? vendorCode;
  String? address;
  String? city;
  String? province;
  String? postalCode;
  int? countryId;
  String? phoneNo;
  String? email;
  String? npwpNumber;
  String? contactPersonName;
  String? contactPersonPhone;
  String? contactPersonEmail;
  String? bankName;
  String? bankAccountNumber;
  String? bankAccountName;
  int? currencyId;
  String? createdDate;
  String? updatedDate;

  VendorFormModel({
    this.encryption,
    this.vendorName,
    this.vendorCode,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.countryId,
    this.phoneNo,
    this.email,
    this.npwpNumber,
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    this.currencyId,
    this.createdDate,
    this.updatedDate,
  });

  factory VendorFormModel.empty() => VendorFormModel();

  factory VendorFormModel.fromDetail(VendorDetailModel detail) {
    final v = detail.vendor;
    return VendorFormModel(
      encryption: v.encryption,
      vendorName: v.vendorName,
      vendorCode: v.vendorCode,
      address: v.address,
      city: v.city,
      province: v.province,
      postalCode: v.postalCode,
      countryId: v.country,
      phoneNo: v.phoneNo,
      email: v.email,
      npwpNumber: v.npwpNumber,
      contactPersonName: v.contactPersonName,
      contactPersonPhone: v.contactPersonPhone,
      contactPersonEmail: v.contactPersonEmail,
      bankName: v.bankName,
      bankAccountNumber: v.bankAccountNumber,
      bankAccountName: v.bankAccountName,
      currencyId: v.currency,
      createdDate: v.createdDate,
      updatedDate: v.updatedDate,
    );
  }

  bool isValid() =>
      vendorName != null && vendorName!.isNotEmpty &&
      vendorCode != null && vendorCode!.isNotEmpty;

  String? validateVendorName() {
    if (vendorName == null || vendorName!.isEmpty) return 'Vendor name is required';
    return null;
  }

  String? validateVendorCode() {
    if (vendorCode == null || vendorCode!.isEmpty) return 'Vendor code is required';
    return null;
  }

  Map<String, dynamic> toJson() => {
        'vendor_name': vendorName,
        'vendor_code': vendorCode,
        'address': address,
        'city': city,
        'province': province,
        'postal_code': postalCode,
        'country': countryId,
        'phone_no': phoneNo,
        'email': email,
        'npwp_number': npwpNumber,
        'contact_person_name': contactPersonName,
        'contact_person_phone': contactPersonPhone,
        'contact_person_email': contactPersonEmail,
        'bank_name': bankName,
        'bank_account_number': bankAccountNumber,
        'bank_account_name': bankAccountName,
        'currency': currencyId,
      };
}