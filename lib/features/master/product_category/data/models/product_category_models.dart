class ProductCategoryPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ProductCategoryPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory ProductCategoryPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ProductCategoryPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ProductCategoryModel {
  final String encryption;
  final String productCategoryName;
  final String? createdDate;

  ProductCategoryModel({
    required this.encryption,
    required this.productCategoryName,
    this.createdDate,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      encryption: json['encryption'] ?? '',
      productCategoryName: json['product_category_name'] ?? '',
      createdDate: json['created_date'],
    );
  }
}

class ProductCategoryDetailModel {
  final ProductCategoryData category;
  final String? createdByName;
  final String? updatedByName;

  ProductCategoryDetailModel({
    required this.category,
    this.createdByName,
    this.updatedByName,
  });

  factory ProductCategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryDetailModel(
      category: ProductCategoryData.fromJson(json['data']),
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}

class ProductCategoryData {
  final String encryption;
  final String productCategoryName;
  final String? createdDate;
  final String? updatedDate;

  ProductCategoryData({
    required this.encryption,
    required this.productCategoryName,
    this.createdDate,
    this.updatedDate,
  });

  factory ProductCategoryData.fromJson(Map<String, dynamic> json) {
    return ProductCategoryData(
      encryption: json['encryption'] ?? '',
      productCategoryName: json['product_category_name'] ?? '',
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }
}

class ProductCategoryFormModel {
  String? encryption;
  String? productCategoryName;
  String? createdDate;
  String? updatedDate;
  String? createdByName;
  String? updatedByName;

  ProductCategoryFormModel({
    this.encryption,
    this.productCategoryName,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
  });

  factory ProductCategoryFormModel.empty() => ProductCategoryFormModel();

  factory ProductCategoryFormModel.fromDetail(ProductCategoryDetailModel detail) {
    return ProductCategoryFormModel(
      encryption: detail.category.encryption,
      productCategoryName: detail.category.productCategoryName,
      createdDate: detail.category.createdDate,
      updatedDate: detail.category.updatedDate,
      createdByName: detail.createdByName,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() => productCategoryName != null && productCategoryName!.isNotEmpty;

  String? validateCategoryName() {
    if (productCategoryName == null || productCategoryName!.isEmpty) {
      return 'Category name is required';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_category_name': productCategoryName,
    };
  }
}