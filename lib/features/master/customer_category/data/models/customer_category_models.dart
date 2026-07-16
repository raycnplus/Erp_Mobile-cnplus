class CustomerCategoryPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  CustomerCategoryPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CustomerCategoryPaginationMeta.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class CustomerCategoryModel {
  final String encryption;
  final String customerCategoryName;
  final String customerCategoryCode;
  final String? description;
  final String? createdDate;

  CustomerCategoryModel({
    required this.encryption,
    required this.customerCategoryName,
    required this.customerCategoryCode,
    this.description,
    this.createdDate,
  });

  factory CustomerCategoryModel.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryModel(
      encryption: json['encryption'] ?? '',
      customerCategoryName: json['customer_category_name'] ?? '',
      customerCategoryCode: json['customer_category_code'] ?? '',
      description: json['description'],
      createdDate: json['created_date'],
    );
  }
}

class CustomerCategoryDetailModel {
  final CustomerCategoryData category;
  final String? createdByName;
  final String? updatedByName;

  CustomerCategoryDetailModel({
    required this.category,
    this.createdByName,
    this.updatedByName,
  });

  factory CustomerCategoryDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CustomerCategoryDetailModel(
      category: CustomerCategoryData.fromJson(data),
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class CustomerCategoryData {
  final String encryption;
  final String customerCategoryName;
  final String customerCategoryCode;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  CustomerCategoryData({
    required this.encryption,
    required this.customerCategoryName,
    required this.customerCategoryCode,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory CustomerCategoryData.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryData(
      encryption: json['encryption'] ?? '',
      customerCategoryName: json['customer_category_name'] ?? '',
      customerCategoryCode: json['customer_category_code'] ?? '',
      description: json['description'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }
}

class CustomerCategoryFormModel {
  String? encryption;
  String customerCategoryName;
  String customerCategoryCode;
  String description;
  String? createdDate;
  String? createdByName;
  String? updatedDate;
  String? updatedByName;

  CustomerCategoryFormModel({
    this.encryption,
    this.customerCategoryName = '',
    this.customerCategoryCode = '',
    this.description = '',
    this.createdDate,
    this.createdByName,
    this.updatedDate,
    this.updatedByName,
  });

  factory CustomerCategoryFormModel.fromDetail(
      CustomerCategoryDetailModel detail) {
    return CustomerCategoryFormModel(
      encryption: detail.category.encryption,
      customerCategoryName: detail.category.customerCategoryName,
      customerCategoryCode: detail.category.customerCategoryCode,
      description: detail.category.description ?? '',
      createdDate: detail.category.createdDate,
      createdByName: detail.createdByName,
      updatedDate: detail.category.updatedDate,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() =>
      customerCategoryName.trim().isNotEmpty &&
      customerCategoryCode.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'customer_category_name': customerCategoryName,
        'customer_category_code': customerCategoryCode,
        'description': description.isEmpty ? null : description,
      };
}