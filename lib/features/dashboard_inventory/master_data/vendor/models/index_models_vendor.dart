class VendorIndexModel {
  final int idVendor;
  final String vendorName;
  final String email;
  final String contactPersonName;
  final String city;

  VendorIndexModel({
    required this.idVendor,
    required this.vendorName,
    required this.email,
    required this.contactPersonName,
    required this.city,
  });

  factory VendorIndexModel.fromJson(Map<String, dynamic> json) {
    return VendorIndexModel(
      idVendor: json['id_vendor'] ?? 0,
      vendorName: json['vendor_name'] ?? '-',
      email: json['email'] ?? '-',
      contactPersonName: json['contact_person_name'] ?? '-',
      city: json['city'] ?? '-',
    );
  }
}
