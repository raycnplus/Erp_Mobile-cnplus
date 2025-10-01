class VendorShowModel {
  final int? idVendor;
  final String? encryption;
  final String? vendorCode;
  final String? vendorName;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? country;
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
  final String? productType;
  final String? currency;
  final String? categoryVendor;
  final String? supportDocument;
  final String? createdDate;
  final String? createdBy;
  final String? updatedDate;
  final String? updatedBy;
  final String? deletedDate;
  final String? deletedBy;
  final String? isDelete;

  VendorShowModel({
    this.idVendor,
    this.encryption,
    this.vendorCode,
    this.vendorName,
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
    this.productType,
    this.currency,
    this.categoryVendor,
    this.supportDocument,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.deletedDate,
    this.deletedBy,
    this.isDelete,
  });

  factory VendorShowModel.fromJson(Map<String, dynamic> json) {
    return VendorShowModel(
      idVendor: json['id_vendor'],
      encryption: json['encryption'],
      vendorCode: json['vendor_code'],
      vendorName: json['vendor_name'],
      address: json['address'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code']?.toString(),
      country: json['country']?.toString(),
      phoneNo: json['phone_no'],
      email: json['email'],
      npwpNumber: json['npwp_number'],
      contactPersonName: json['contact_person_name'],
      contactPersonPhone: json['contact_person_phone'],
      contactPersonEmail: json['contact_person_email'],
      bankName: json['bank_name'],
      bankAccountNumber: json['bank_account_number'],
      bankAccountName: json['bank_account_name'],
      status: json['status'],
      productType: json['product_type'],
      currency: json['currency']?.toString(),
      categoryVendor: json['category_vendor'],
      supportDocument: json['support_document'],
      createdDate: json['created_date'],
      createdBy: json['created_by']?.toString(),
      updatedDate: json['updated_date'],
      updatedBy: json['updated_by']?.toString(),
      deletedDate: json['deleted_date'],
      deletedBy: json['deleted_by']?.toString(),
      isDelete: json['is_delete'],
    );
  }
}
