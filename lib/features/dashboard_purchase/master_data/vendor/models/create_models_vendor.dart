class VendorCreateResponse {
  final int idVendor;
  final String encryption;
  final String vendorCode;
  final String vendorName;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final int? country;
  final String? phoneNo;
  final String? email;
  final String? npwpNumber;
  final String? contactPersonName;
  final String? contactPersonPhone;
  final String? contactPersonEmail;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final String? status;
  final int? currency;

  VendorCreateResponse({
    required this.idVendor,
    required this.encryption,
    required this.vendorCode,
    required this.vendorName,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.country,
    this.phoneNo,
    this.email,
    this.npwpNumber,
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    this.status,
    this.currency,
  });

  factory VendorCreateResponse.fromJson(Map<String, dynamic> json) {
    return VendorCreateResponse(
      idVendor: json["id_vendor"],
      encryption: json["encryption"],
      vendorCode: json["vendor_code"],
      vendorName: json["vendor_name"],
      address: json["address"],
      city: json["city"],
      province: json["province"],
      postalCode: json["postal_code"]?.toString(),
      country: json["country"],
      phoneNo: json["phone_no"],
      email: json["email"],
      npwpNumber: json["npwp_number"],
      contactPersonName: json["contact_person_name"],
      contactPersonPhone: json["contact_person_phone"],
      contactPersonEmail: json["contact_person_email"],
      bankName: json["bank_name"],
      bankAccountNumber: json["bank_account_number"],
      bankAccountName: json["bank_account_name"],
      status: json["status"],
      currency: json["currency"],
    );
  }
} 

class CountryModel {
  final int id;
  final String name;

  CountryModel({required this.id, required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id_country'],
      name: json['name'],
    );
  }
}


class CurrencyModel {
  final int id;
  final String name;

  CurrencyModel({required this.id, required this.name});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json["id"],
      name: json["currency_name"],
    );
  }
}



