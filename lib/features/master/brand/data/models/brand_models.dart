class BrandPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  BrandPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory BrandPaginationMeta.fromJson(Map<String, dynamic> json) {
    return BrandPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class BrandModel {
  final String encryption;
  final String brandName;
  final String brandCode;
  final String? createdDate;

  BrandModel({
    required this.encryption,
    required this.brandName,
    required this.brandCode,
    this.createdDate,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      encryption: json['encryption'] ?? '',
      brandName: json['brand_name'] ?? '',
      brandCode: json['brand_code'] ?? '-',
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encryption': encryption,
      'brand_name': brandName,
      'brand_code': brandCode,
      if (createdDate != null) 'created_date': createdDate,
    };
  }
}


class BrandDetailModel {
  final BrandData brand;
  final String? createdByName;
  final String? updatedByName;

  BrandDetailModel({
    required this.brand,
    this.createdByName,
    this.updatedByName,
  });

  factory BrandDetailModel.fromJson(Map<String, dynamic> json) {
    return BrandDetailModel(
      brand: BrandData.fromJson(json['data']),
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}

class BrandData {
  final String encryption;
  final String brandName;
  final String brandCode;
  final String? createdDate;
  final String? updatedDate;

  BrandData({
    required this.encryption,
    required this.brandName,
    required this.brandCode,
    this.createdDate,
    this.updatedDate,
  });

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(
      encryption: json['encryption'] ?? '',
      brandName: json['brand_name'] ?? '',
      brandCode: json['brand_code'] ?? '-',
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }
}

class BrandFormModel {
  String? encryption;
  String? brandName;
  String? brandCode;
  String? createdDate;
  String? updatedDate;
  String? createdByName;
  String? updatedByName;

  BrandFormModel({
    this.encryption,
    this.brandName,
    this.brandCode,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
  });

  factory BrandFormModel.empty() => BrandFormModel();

  factory BrandFormModel.fromDetail(BrandDetailModel detail) {
    return BrandFormModel(
      encryption: detail.brand.encryption,
      brandName: detail.brand.brandName,
      brandCode: detail.brand.brandCode,
      createdDate: detail.brand.createdDate,
      updatedDate: detail.brand.updatedDate,
      createdByName: detail.createdByName,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() => brandName != null && brandName!.isNotEmpty;

  String? validateBrandName() {
    if (brandName == null || brandName!.isEmpty) return "Brand name is required";
    return null;
  }

  String? validateBrandCode() => null; 

  Map<String, dynamic> toJson() {
    return {
      'brand_name': brandName,
      if (brandCode != null && brandCode!.isNotEmpty) 'brand_code': brandCode,
    };
  }
}