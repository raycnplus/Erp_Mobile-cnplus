import 'dart:convert';
import 'package:dio/dio.dart';

class ProductPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ProductPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ProductPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ProductPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class ProductModel {
  final String encryption;
  final String productName;
  final String productCode;
  final double? salesPrice;
  final double? purchasePrice;
  final num onHand;
  final String? image;

  ProductModel({
    required this.encryption,
    required this.productName,
    required this.productCode,
    this.salesPrice,
    this.purchasePrice,
    required this.onHand,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      encryption: json['encryption'] ?? '',
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      salesPrice: _parseDouble(json['sales_price']),
      purchasePrice: _parseDouble(json['purchase_price']),
      onHand: _parseNum(json['on_hand']) ?? 0,
      image: json['image'],
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static num? _parseNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}

class ProductDetailModel {
  final ProductData product;
  final ProductDetailData productDetail;
  final InventoryData inventory;
  final String? createdByName;
  final String? updatedByName;
  final int warehouseCount;
  final int locationCount;
  final num onHand;
  final num forecasted;

  ProductDetailModel({
    required this.product,
    required this.productDetail,
    required this.inventory,
    this.createdByName,
    this.updatedByName,
    required this.warehouseCount,
    required this.locationCount,
    required this.onHand,
    required this.forecasted,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ProductDetailModel(
      product: ProductData.fromJson(data['product']),
      productDetail: data['product_detail'] != null
          ? ProductDetailData.fromJson(data['product_detail'])
          : ProductDetailData.empty(),
      inventory: data['inventory'] != null
          ? InventoryData.fromJson(data['inventory'])
          : InventoryData.empty(),
      createdByName: data['created_by_name'],
      updatedByName: data['updated_by_name'],
      warehouseCount: _parseInt(data['warehouse_count']),
      locationCount: _parseInt(data['location_count']),
      onHand: _parseNum(data['on_hand']),
      forecasted: _parseNum(data['forecasted']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }
}

class ProductData {
  final String encryption;
  final String productCode;
  final String productName;
  final bool sales;
  final bool purchase;
  final bool pointOfSale;
  final bool directPurchase;
  final bool expense;
  final String? image;
  final String? createdDate;
  final String? updatedDate;

  ProductData({
    required this.encryption,
    required this.productCode,
    required this.productName,
    required this.sales,
    required this.purchase,
    required this.pointOfSale,
    required this.directPurchase,
    required this.expense,
    this.image,
    this.createdDate,
    this.updatedDate,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      encryption: json['encryption'] ?? '',
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      sales: json['sales'] == 1 || json['sales'] == true,
      purchase: json['purchase'] == 1 || json['purchase'] == true,
      pointOfSale: json['pos'] == 1 || json['pos'] == true,
      directPurchase: json['direct'] == 1 || json['direct'] == true,
      expense: json['expense'] == 1 || json['expense'] == true,
      image: json['image'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }
}

class ProductDetailData {
  final double? salesPrice;
  final double? purchasePrice;
  final String barcode;
  final int? productType;
  final int? productCategory;
  final int? productBrand;
  final int? unitOfMeasure;
  final String? unitOfMeasureName;
  final String? brandName;
  final String? noteDetail;
  final String? productTypeName;
  final String? productCategoryName;

  ProductDetailData({
    this.salesPrice,
    this.purchasePrice,
    required this.barcode,
    this.productType,
    this.productCategory,
    this.productBrand,
    this.unitOfMeasure,
    this.unitOfMeasureName,
    this.brandName,
    this.noteDetail,
    this.productTypeName,
    this.productCategoryName,
  });

  factory ProductDetailData.empty() => ProductDetailData(barcode: '');

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      salesPrice: _parseDouble(json['sales_price']),
      purchasePrice: _parseDouble(json['purchase_price']),
      barcode: json['barcode']?.toString() ?? '',
      productType: _parseInt(json['product_type']),
      productTypeName: json['product_type_name'],
      productCategory: _parseInt(json['product_category']),
      productCategoryName: json['product_category_name'],
      productBrand: _parseInt(json['product_brand']),
      brandName: json['brand_name'],
      unitOfMeasure: _parseInt(json['unit_of_measure']),
      unitOfMeasureName: json['unit_of_measure_name'],
      noteDetail: json['note_detail'],
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class InventoryData {
  final double weight;
  final double length;
  final double width;
  final double height;
  final double volume;
  final String? noteInventory;
  final bool tracking;
  final String? trackingMethod;
  final bool useExpiration;
  final int? expirationDays;
  final int? bestBeforeDays;
  final int? removalDays;
  final int? alertDays;
  final bool autoGenerateLot;
  final String? lotPrefix;
  final String? lotSuffix;
  final int? lotDigitNumber;

  InventoryData({
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.volume,
    this.noteInventory,
    required this.tracking,
    this.trackingMethod,
    required this.useExpiration,
    this.expirationDays,
    this.bestBeforeDays,
    this.removalDays,
    this.alertDays,
    required this.autoGenerateLot,
    this.lotPrefix,
    this.lotSuffix,
    this.lotDigitNumber,
  });

  factory InventoryData.empty() => InventoryData(
        weight: 0,
        length: 0,
        width: 0,
        height: 0,
        volume: 0,
        tracking: false,
        useExpiration: false,
        autoGenerateLot: false,
      );

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      weight: _parseDouble(json['weight']),
      length: _parseDouble(json['length']),
      width: _parseDouble(json['width']),
      height: _parseDouble(json['height']),
      volume: _parseDouble(json['volume']),
      noteInventory: json['note_inventory'],
      tracking: json['tracking'] == 1 || json['tracking'] == true,
      trackingMethod: json['tracking_method'],
      useExpiration:
          json['use_expiration'] == 1 || json['use_expiration'] == true,
      expirationDays: _parseInt(json['expiration_days']),
      bestBeforeDays: _parseInt(json['best_before_days']),
      removalDays: _parseInt(json['removal_days']),
      alertDays: _parseInt(json['alert_days']),
      autoGenerateLot:
          json['auto_generate_lot'] == 1 || json['auto_generate_lot'] == true,
      lotPrefix: json['lot_prefix'],
      lotSuffix: json['lot_suffix'],
      lotDigitNumber: _parseInt(json['lot_digit_number']),
    );
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class ProductDropdownData {
  final List<DropdownProductType> productTypes;
  final List<DropdownProductCategory> categories;
  final List<DropdownProductBrand> brands;
  final List<DropdownUnitOfMeasure> uoms;
  final int? defaultUomId;

  ProductDropdownData({
    required this.productTypes,
    required this.categories,
    required this.brands,
    required this.uoms,
    this.defaultUomId,
  });

  factory ProductDropdownData.fromJson(Map<String, dynamic> json) {
    return ProductDropdownData(
      productTypes: (json['product_types'] as List? ?? [])
          .map((e) => DropdownProductType.fromJson(e))
          .toList(),
      categories: (json['categories'] as List? ?? [])
          .map((e) => DropdownProductCategory.fromJson(e))
          .toList(),
      brands: (json['brands'] as List? ?? [])
          .map((e) => DropdownProductBrand.fromJson(e))
          .toList(),
      uoms: (json['uoms'] as List? ?? [])
          .map((e) => DropdownUnitOfMeasure.fromJson(e))
          .toList(),
      defaultUomId: json['default_uom_id'] != null
          ? int.tryParse(json['default_uom_id'].toString())
          : null,
    );
  }
}

class DropdownProductType {
  final int id;
  final String name;
  DropdownProductType({required this.id, required this.name});

  factory DropdownProductType.fromJson(Map<String, dynamic> json) =>
      DropdownProductType(
        id: int.parse(json['id_product_type'].toString()),
        name: json['product_type_name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is DropdownProductType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DropdownProductCategory {
  final int id;
  final String name;
  DropdownProductCategory({required this.id, required this.name});

  factory DropdownProductCategory.fromJson(Map<String, dynamic> json) =>
      DropdownProductCategory(
        id: int.parse(json['id_product_category'].toString()),
        name: json['product_category_name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is DropdownProductCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DropdownProductBrand {
  final int id;
  final String name;
  DropdownProductBrand({required this.id, required this.name});

  factory DropdownProductBrand.fromJson(Map<String, dynamic> json) =>
      DropdownProductBrand(
        id: int.parse(json['id_brand'].toString()),
        name: json['brand_name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is DropdownProductBrand && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DropdownUnitOfMeasure {
  final int id;
  final String name;
  DropdownUnitOfMeasure({required this.id, required this.name});

  factory DropdownUnitOfMeasure.fromJson(Map<String, dynamic> json) =>
      DropdownUnitOfMeasure(
        id: int.parse(json['id_unit_of_measure'].toString()),
        name: json['unit_of_measure_name'] ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is DropdownUnitOfMeasure && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ProductFormModel {
  String? encryption;
  String productName;
  String productCode;
  bool sales;
  bool purchase;
  bool pointOfSale;
  bool directPurchase;
  bool expense;

  int? productType;
  int? productCategory;
  int? productBrand;
  int? unitOfMeasure;
  double? salesPrice;
  double? purchasePrice;
  String barcode;
  String noteDetail;

  double weight;
  double length;
  double width;
  double height;
  double volume;
  String noteInventory;
  bool tracking;
  String? trackingMethod;
  bool useExpiration;
  int? expirationDays;
  int? bestBeforeDays;
  int? removalDays;
  int? alertDays;
  bool autoGenerateLot;
  String? lotPrefix;
  String? lotSuffix;
  int? lotDigitNumber;

  String? createdDate;
  String? createdByName;
  String? updatedDate;
  String? updatedByName;

  ProductFormModel({
    this.encryption,
    this.productName = '',
    this.productCode = '',
    this.sales = true,
    this.purchase = true,
    this.pointOfSale = true,
    this.directPurchase = true,
    this.expense = true,
    this.productType,
    this.productCategory,
    this.productBrand,
    this.unitOfMeasure,
    this.salesPrice,
    this.purchasePrice,
    this.barcode = '',
    this.noteDetail = '',
    this.weight = 0,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.volume = 0,
    this.noteInventory = '',
    this.tracking = false,
    this.trackingMethod,
    this.useExpiration = false,
    this.expirationDays,
    this.bestBeforeDays,
    this.removalDays,
    this.alertDays,
    this.autoGenerateLot = false,
    this.lotPrefix,
    this.lotSuffix,
    this.lotDigitNumber,
    this.createdDate,
    this.createdByName,
    this.updatedDate,
    this.updatedByName,
  });

  factory ProductFormModel.fromDetail(ProductDetailModel detail) {
    final p = detail.product;
    final d = detail.productDetail;
    final i = detail.inventory;
    return ProductFormModel(
      encryption: p.encryption,
      productName: p.productName,
      productCode: p.productCode,
      sales: p.sales,
      purchase: p.purchase,
      pointOfSale: p.pointOfSale,
      directPurchase: p.directPurchase,
      expense: p.expense,
      productType: d.productType,
      productCategory: d.productCategory,
      productBrand: d.productBrand,
      unitOfMeasure: d.unitOfMeasure,
      salesPrice: d.salesPrice,
      purchasePrice: d.purchasePrice,
      barcode: d.barcode,
      noteDetail: d.noteDetail ?? '',
      weight: i.weight,
      length: i.length,
      width: i.width,
      height: i.height,
      volume: i.volume,
      noteInventory: i.noteInventory ?? '',
      tracking: i.tracking,
      trackingMethod: i.trackingMethod,
      useExpiration: i.useExpiration,
      expirationDays: i.expirationDays,
      bestBeforeDays: i.bestBeforeDays,
      removalDays: i.removalDays,
      alertDays: i.alertDays,
      autoGenerateLot: i.autoGenerateLot,
      lotPrefix: i.lotPrefix,
      lotSuffix: i.lotSuffix,
      lotDigitNumber: i.lotDigitNumber,
      createdDate: p.createdDate,
      createdByName: detail.createdByName,
      updatedDate: p.updatedDate,
      updatedByName: detail.updatedByName,
    );
  }

  bool isValid() =>
      productName.trim().isNotEmpty &&
      productCode.trim().isNotEmpty &&
      productType != null &&
      productCategory != null &&
      productBrand != null &&       
      unitOfMeasure != null &&
      (!tracking || (trackingMethod != null && trackingMethod!.isNotEmpty));

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_code': productCode,
      'sales': sales ? 1 : 0,
      'purchase': purchase ? 1 : 0,
      'pos': pointOfSale ? 1 : 0,
      'direct_purchase': directPurchase ? 1 : 0,
      'expense': expense ? 1 : 0,
      'product_detail': {
        'product_type': productType,
        'product_category': productCategory,
        'product_brand': productBrand,
        'unit_of_measure': unitOfMeasure,
        'sales_price': salesPrice,
        'purchase_price': purchasePrice,
        'barcode': barcode.isEmpty ? null : barcode,
        'note_detail': noteDetail.isEmpty ? null : noteDetail,
      },
      'inventory': {
        'weight': weight == 0 ? null : weight,
        'length': length == 0 ? null : length,
        'width': width == 0 ? null : width,
        'height': height == 0 ? null : height,
        'volume': volume == 0 ? null : volume,
        'note_inventory': noteInventory.isEmpty ? null : noteInventory,
        'tracking': tracking ? 1 : 0,
        'tracking_method': tracking ? trackingMethod : null,
        'use_expiration': useExpiration ? 1 : 0,
        'expiration_days': expirationDays,
        'best_before_days': bestBeforeDays,
        'removal_days': removalDays,
        'alert_days': alertDays,
        'auto_generate_lot': autoGenerateLot ? 1 : 0,
        'lot_prefix': lotPrefix,
        'lot_suffix': lotSuffix,
        'lot_digit_number': lotDigitNumber,
      },
    };
  }

  FormData toMultipartData({bool isUpdate = false}) {
    final detail = {
      'product_type': productType,
      'product_category': productCategory,
      'product_brand': productBrand,
      'unit_of_measure': unitOfMeasure,
      'sales_price': salesPrice,
      'purchase_price': purchasePrice,
      'barcode': barcode.isEmpty ? null : barcode,
      'note_detail': noteDetail.isEmpty ? null : noteDetail,
    };

    final inventoryMap = {
      'weight': weight == 0 ? null : weight,
      'length': length == 0 ? null : length,
      'width': width == 0 ? null : width,
      'height': height == 0 ? null : height,
      'volume': volume == 0 ? null : volume,
      'note_inventory': noteInventory.isEmpty ? null : noteInventory,
      'tracking': tracking ? 1 : 0,
      'tracking_method': tracking ? trackingMethod : null,
      'use_expiration': useExpiration ? 1 : 0,
      'expiration_days': expirationDays,
      'best_before_days': bestBeforeDays,
      'removal_days': removalDays,
      'alert_days': alertDays,
      'auto_generate_lot': autoGenerateLot ? 1 : 0,
      'lot_prefix': lotPrefix,
      'lot_suffix': lotSuffix,
      'lot_digit_number': lotDigitNumber,
    };

    return FormData.fromMap({
      if (isUpdate) '_method': 'PUT',
      'product_name': productName,
      'product_code': productCode,
      'sales': sales ? 1 : 0,
      'purchase': purchase ? 1 : 0,
      'pos': pointOfSale ? 1 : 0,
      'direct_purchase': directPurchase ? 1 : 0,
      'expense': expense ? 1 : 0,
      'product_detail': jsonEncode(detail),
      'inventory': jsonEncode(inventoryMap),
    });
  }
}