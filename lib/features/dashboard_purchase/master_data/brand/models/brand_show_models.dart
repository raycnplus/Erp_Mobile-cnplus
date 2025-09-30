class BrandShowModel {
  final int brandId;
  final String brandName;
  final String brandCode; // Diubah agar tidak nullable, tapi diberi nilai default ahmad2025
  final String? createdDate;
  final String? updatedDate;

  BrandShowModel({
    required this.brandId,
    required this.brandName,
    required this.brandCode,
    this.createdDate,
    this.updatedDate,
  });

  factory BrandShowModel.fromJson(Map<String, dynamic> json) {
    return BrandShowModel(
      brandId: int.parse(json['id_brand'].toString()),
      
      // ## PERBAIKAN  ##
      //  null-aware operator (??) untuk memberikan nilai default
      brandName: json['brand_name'] ?? 'No Name', 
      brandCode: json['brand_code'] ?? '-', // Jika brand_code null, beri nilai '-'
      
      createdDate: json['created_date'], // Tidak perlu 'as String?' karena sudah nullable
      updatedDate: json['updated_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_brand" : brandId,
      "brand_name": brandName,
      "brand_code": brandCode,
      "created_date": createdDate,
      "updated_date": updatedDate,
    };
  }
}