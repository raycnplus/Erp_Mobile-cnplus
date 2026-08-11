class PriceListPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  PriceListPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PriceListPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return PriceListPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class PriceListModel {
  final String encryption;
  final String priceListName;
  final String? description;
  final String isActive;
  final int itemCount;

  PriceListModel({
    required this.encryption,
    required this.priceListName,
    this.description,
    this.isActive = 'Y',
    this.itemCount = 0,
  });

  factory PriceListModel.fromJson(Map<String, dynamic> json) => PriceListModel(
    encryption: json['encryption']?.toString() ?? '',
    priceListName: json['price_list_name']?.toString() ?? '',
    description: json['description']?.toString(),
    isActive: json['is_active']?.toString() ?? 'Y',
    itemCount: int.tryParse(json['item_count']?.toString() ?? '0') ?? 0,
  );
}

class PriceListItem {
  final int idProduct;
  final String productName;
  final String productCode;
  final double originalPrice;
  final double customPrice;

  PriceListItem({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    required this.originalPrice,
    required this.customPrice,
  });

  factory PriceListItem.fromJson(Map<String, dynamic> json) {
    double p(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return PriceListItem(
      idProduct: json['id_product'] is int
          ? json['id_product']
          : int.tryParse(json['id_product']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? '',
      originalPrice: p(json['original_price']),
      customPrice: p(json['custom_price']),
    );
  }
}

class PriceListDetailModel {
  final PriceListData priceList;
  final List<PriceListItem> items;
  final int itemCount;
  final String? createdByName;
  final String? updatedByName;

  PriceListDetailModel({
    required this.priceList,
    required this.items,
    this.itemCount = 0,
    this.createdByName,
    this.updatedByName,
  });

  factory PriceListDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PriceListDetailModel(
      priceList: PriceListData.fromJson(data),
      items: (json['items'] as List? ?? []).map((e) => PriceListItem.fromJson(e)).toList(),
      itemCount: int.tryParse(json['item_count']?.toString() ?? '0') ?? 0,
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class PriceListData {
  final String encryption;
  final String priceListName;
  final String? description;
  final String isActive;
  final String? createdDate;
  final String? updatedDate;

  PriceListData({
    required this.encryption,
    required this.priceListName,
    this.description,
    this.isActive = 'Y',
    this.createdDate,
    this.updatedDate,
  });

  factory PriceListData.fromJson(Map<String, dynamic> json) => PriceListData(
    encryption: json['encryption']?.toString() ?? '',
    priceListName: json['price_list_name']?.toString() ?? '',
    description: json['description']?.toString(),
    isActive: json['is_active']?.toString() ?? 'Y',
    createdDate: json['created_date']?.toString(),
    updatedDate: json['updated_date']?.toString(),
  );
}

class PriceListProductOption {
  final int id;
  final String productName;
  final String productCode;
  final double salesPrice;

  PriceListProductOption({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.salesPrice,
  });

  factory PriceListProductOption.fromJson(Map<String, dynamic> json) {
    double p(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return PriceListProductOption(
      id: json['id_product'] is int
          ? json['id_product']
          : int.tryParse(json['id_product']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? '',
      salesPrice: p(json['sales_price']),
    );
  }

  @override
  bool operator ==(Object o) => o is PriceListProductOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PriceListFormItem {
  final int idProduct;
  final String productName;
  final String productCode;
  final double originalPrice;
  double customPrice;

  PriceListFormItem({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    required this.originalPrice,
    required this.customPrice,
  });

  Map<String, dynamic> toJson() => {'id_product': idProduct, 'custom_price': customPrice};
}

class PriceListFormModel {
  String? encryption;
  String priceListName;
  String? description;
  String isActive;
  List<PriceListFormItem> items;

  PriceListFormModel({
    this.encryption,
    this.priceListName = '',
    this.description,
    this.isActive = 'Y',
    List<PriceListFormItem>? items,
  }) : items = items ?? [];

  factory PriceListFormModel.fromDetail(PriceListDetailModel detail) {
    final d = detail.priceList;
    return PriceListFormModel(
      encryption: d.encryption,
      priceListName: d.priceListName,
      description: d.description,
      isActive: d.isActive,
      items: detail.items.map((item) => PriceListFormItem(
        idProduct: item.idProduct,
        productName: item.productName,
        productCode: item.productCode,
        originalPrice: item.originalPrice,
        customPrice: item.customPrice,
      )).toList(),
    );
  }

  bool isValid() => priceListName.trim().isNotEmpty && items.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'price_list_name': priceListName,
    if (description != null && description!.isNotEmpty) 'description': description,
    'is_active': isActive,
    'items': items.map((i) => i.toJson()).toList(),
  };
}