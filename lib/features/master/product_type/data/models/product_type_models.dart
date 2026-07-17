class ProductTypePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ProductTypePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ProductTypePaginationMeta.fromJson(Map<String, dynamic> json) {
    final meta = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return ProductTypePaginationMeta(
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class ProductTypeModel {
  final String encryption;
  final String productTypeName;

  ProductTypeModel({required this.encryption, required this.productTypeName});

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      encryption: json['encryption'] ?? '',
      productTypeName: json['product_type_name'] ?? '',
    );
  }
}

class ProductTypeDetailModel {
  final ProductTypeData productType;
  final String? createdByName;
  final String? updatedByName;

  ProductTypeDetailModel({
    required this.productType,
    this.createdByName,
    this.updatedByName,
  });

  factory ProductTypeDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ProductTypeDetailModel(
      productType: ProductTypeData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class ProductTypeData {
  final String encryption;
  final String productTypeName;
  final String? createdDate;
  final String? updatedDate;

  ProductTypeData({
    required this.encryption,
    required this.productTypeName,
    this.createdDate,
    this.updatedDate,
  });

  factory ProductTypeData.fromJson(Map<String, dynamic> json) {
    return ProductTypeData(
      encryption: json['encryption'] ?? '',
      productTypeName: json['product_type_name'] ?? '',
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class ProductTypeFormModel {
  String productTypeName;
  String? encryption;
  String? createdDate;
  String? updatedDate;

  ProductTypeFormModel({
    this.productTypeName = '',
    this.encryption,
    this.createdDate,
    this.updatedDate,
  });

  factory ProductTypeFormModel.empty() => ProductTypeFormModel();

  factory ProductTypeFormModel.fromDetail(ProductTypeDetailModel detail) {
    return ProductTypeFormModel(
      productTypeName: detail.productType.productTypeName,
      encryption: detail.productType.encryption,
      createdDate: detail.productType.createdDate,
      updatedDate: detail.productType.updatedDate,
    );
  }

  bool isValid() => productTypeName.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'product_type_name': productTypeName.trim(),
      };
}