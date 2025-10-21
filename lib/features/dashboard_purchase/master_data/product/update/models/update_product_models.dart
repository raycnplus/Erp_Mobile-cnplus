// Lokasi: lib/.../product/models/update_product_models.dart

import 'package:equatable/equatable.dart';

// --- FUNGSI HELPER GLOBAL UNTUK PARSING BOOLEAN ---
// Fungsi ini akan mengubah nilai 1 menjadi true, dan nilai lainnya menjadi false.
bool parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}

// --- BAGIAN DATA UTAMA (UNTUK PARSING API) ---

class ProductData {
  final int idProduct;
  final String productName;
  final String productCode;
  final bool sales;
  final bool purchase;
  final bool directPurchase;
  final bool expense;
  final bool pos;

  ProductData({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    required this.sales,
    required this.purchase,
    required this.directPurchase,
    required this.expense,
    required this.pos,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      idProduct: json["id_product"] ?? 0,
      productName: json["product_name"] ?? '',
      productCode: json["product_code"] ?? '',
      sales: parseBool(json["sales"]),
      purchase: parseBool(json["purchase"]),
      directPurchase: parseBool(json["direct"] ?? json["direct_purchase"]),
      expense: parseBool(json["expense"]),
      pos: parseBool(json["pos"] ?? json["point_of_sale"]),
    );
  }
}

class ProductDetailData {
  final int? productType;
  final int? productCategory;
  final int? productBrand;
  final int? unitOfMeasure;
  final double? salesPrice;
  final double? costPrice;
  final double? purchasePrice;
  final String? barcode;
  final String? noteDetail;

  ProductDetailData({
    this.productType,
    this.productCategory,
    this.productBrand,
    this.unitOfMeasure,
    this.salesPrice,
    this.costPrice,
    this.purchasePrice,
    this.barcode,
    this.noteDetail,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return ProductDetailData(
      productType: toInt(json["product_type"]),
      productCategory: toInt(json["product_category"]),
      productBrand: toInt(json["product_brand"]),
      unitOfMeasure: toInt(json["unit_of_measure"]),
      salesPrice: toDouble(json["sales_price"]),
      costPrice: toDouble(json["cost_price"]),
      purchasePrice: toDouble(json["purchase_price"]),
      barcode: json["barcode"]?.toString(),
      noteDetail: json["note_detail"]?.toString(),
    );
  }
}

class InventoryData {
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final double? volume;
  final bool? tracking;
  final String? trackingMethod;
  final String? noteInventory;

  InventoryData({
    this.weight,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.tracking,
    this.trackingMethod,
    this.noteInventory,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    double? toSafeDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed;
      }
      return null;
    }

    return InventoryData(
      weight: toSafeDouble(json["weight"]),
      length: toSafeDouble(json["length"]),
      width: toSafeDouble(json["width"]),
      height: toSafeDouble(json["height"]),
      volume: toSafeDouble(json["volume"]),
      tracking: parseBool(json["tracking"]),
      trackingMethod: json["tracking_method"]?.toString(),
      noteInventory: json["note_inventory"]?.toString(),
    );
  }
}

// --- CLASS WRAPPER UNTUK TAMPILAN SHOW ---
class ProductShowData {
  final ProductData product;
  final ProductDetailData productDetail;
  final InventoryData inventory;
  final String? createdByName;
  final String? categoryName;
  final String? brandName;
  final String? productTypeName;
  final String? uomName;

  ProductShowData({
    required this.product,
    required this.productDetail,
    required this.inventory,
    this.createdByName,
    this.categoryName,
    this.brandName,
    this.productTypeName,
    this.uomName,
  });

  factory ProductShowData.fromJson(Map<String, dynamic> productJson, Map<String, dynamic> dropdownJson) {
    final detail = ProductDetailData.fromJson(productJson['product_detail']);

    String? findNameById(List<dynamic> items, int? id, String idKey, String nameKey) {
      if (id == null || items.isEmpty) return null;
      try {
        final item = items.firstWhere((i) => i[idKey] == id);
        return item[nameKey];
      } catch (e) {
        return id.toString();
      }
    }

    return ProductShowData(
      product: ProductData.fromJson(productJson['product']),
      productDetail: detail,
      inventory: InventoryData.fromJson(productJson['inventory']),
      createdByName: productJson['created_by_name'],
      categoryName: findNameById(dropdownJson['categories'], detail.productCategory, 'id_product_category', 'product_category_name'),
      brandName: findNameById(dropdownJson['brands'], detail.productBrand, 'id_brand', 'brand_name'),
      productTypeName: findNameById(dropdownJson['product_types'], detail.productType, 'id_product_type', 'product_type_name'),
      uomName: findNameById(dropdownJson['uoms'], detail.unitOfMeasure, 'id_unit_of_measure', 'unit_of_measure_name'),
    );
  }
}


// --- BAGIAN DROPDOWN (DENGAN EQUATABLE) ---
class DropdownProductType extends Equatable {
  final int id;
  final String name;
  const DropdownProductType({required this.id, required this.name});
  
  factory DropdownProductType.fromJson(Map<String, dynamic> json) {
    return DropdownProductType(
      id: json['id_product_type'] ?? 0, 
      name: json['product_type_name'] ?? 'Unknown'
    );
  }
  
  @override
  List<Object?> get props => [id];
  
  @override
  String toString() => 'ProductType(id: $id, name: $name)';
}

class DropdownProductCategory extends Equatable {
  final int id;
  final String name;
  const DropdownProductCategory({required this.id, required this.name});
  
  factory DropdownProductCategory.fromJson(Map<String, dynamic> json) {
    return DropdownProductCategory(
      id: json['id_product_category'] ?? 0, 
      name: json['product_category_name'] ?? 'Unknown'
    );
  }
  
  @override
  List<Object?> get props => [id];
  
  @override
  String toString() => 'Category(id: $id, name: $name)';
}

class DropdownUnitOfMeasure extends Equatable {
  final int id;
  final String name;
  const DropdownUnitOfMeasure({required this.id, required this.name});
  
  factory DropdownUnitOfMeasure.fromJson(Map<String, dynamic> json) {
    return DropdownUnitOfMeasure(
      id: json['id_unit_of_measure'] ?? 0, 
      name: json['unit_of_measure_name'] ?? 'Unknown'
    );
  }
  
  @override
  List<Object?> get props => [id];
  
  @override
  String toString() => 'UOM(id: $id, name: $name)';
}

class DropdownProductBrand extends Equatable {
  final int id;
  final String name;
  const DropdownProductBrand({required this.id, required this.name});
  
  factory DropdownProductBrand.fromJson(Map<String, dynamic> json) {
    return DropdownProductBrand(
      id: json['id_brand'] ?? 0, 
      name: json['brand_name'] ?? 'Unknown'
    );
  }
  
  @override
  List<Object?> get props => [id];
  
  @override
  String toString() => 'Brand(id: $id, name: $name)';
}