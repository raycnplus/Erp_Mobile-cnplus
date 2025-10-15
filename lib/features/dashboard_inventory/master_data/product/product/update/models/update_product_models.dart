import 'package:flutter/material.dart';

// ---------------- PRODUCT ----------------
class ProductData {
  final int idProduct;
  final String encryption;
  final String productName;
  final String productCode;
  final bool sales;
  final bool purchase;
  final bool directPurchase;
  final bool expense;

  ProductData({
    required this.idProduct,
    required this.encryption,
    required this.productName,
    required this.productCode,
    required this.sales,
    required this.purchase,
    required this.directPurchase,
    required this.expense,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      idProduct: json["id_product"],
      encryption: json["encryption"],
      productName: json["product_name"],
      productCode: json["product_code"],
      sales: json["sales"] == true,
      purchase: json["purchase"] == true,
      directPurchase: json["direct"] == true || json["direct_purchase"] == true,
      expense: json["expense"] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_name": productName,
      "product_code": productCode,
      "sales": sales,
      "purchase": purchase,
      "direct_purchase": directPurchase,
      "expense": expense,
    };
  }
}

// ---------------- PRODUCT DETAIL ----------------
class ProductDetailData {
  final int? idProductDetail;
  final int? productType;
  final int? productCategory;
  final int? productBrand;
  final int? unitOfMeasure;
  final double? salesPrice;
  final double? purchasePrice;
  final String? barcode;
  final String? noteDetail;

  ProductDetailData({
    this.idProductDetail,
    this.productType,
    this.productCategory,
    this.productBrand,
    this.unitOfMeasure,
    this.salesPrice,
    this.purchasePrice,
    this.barcode,
    this.noteDetail,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      idProductDetail: json["id_product_detail"],
      productType: json["product_type"],
      productCategory: json["product_category"],
      productBrand: json["product_brand"],
      unitOfMeasure: json["unit_of_measure"],
      salesPrice: (json["sales_price"] ?? 0).toDouble(),
      purchasePrice: (json["purchase_price"] ?? 0).toDouble(),
      barcode: json["barcode"],
      noteDetail: json["note_detail"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_type": productType,
      "product_category": productCategory,
      "product_brand": productBrand,
      "unit_of_measure": unitOfMeasure,
      "sales_price": salesPrice,
      "purchase_price": purchasePrice,
      "barcode": barcode,
      "note_detail": noteDetail,
    };
  }
}

// ---------------- INVENTORY ----------------
class InventoryData {
  final int? idInventory;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final double? volume;
  final bool? tracking;
  final String? trackingMethod;
  final String? noteInventory;

  InventoryData({
    this.idInventory,
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
    return InventoryData(
      idInventory: json["id_inventory"],
      weight: (json["weight"] ?? 0).toDouble(),
      length: (json["length"] ?? 0).toDouble(),
      width: (json["width"] ?? 0).toDouble(),
      height: (json["height"] ?? 0).toDouble(),
      volume: (json["volume"] ?? 0).toDouble(),
      tracking: json["tracking"] ?? false,
      trackingMethod: json["tracking_method"],
      noteInventory: json["note_inventory"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "weight": weight,
      "length": length,
      "width": width,
      "height": height,
      "volume": volume,
      "note_inventory": noteInventory,
      "tracking": tracking,
      "tracking_method": trackingMethod,
    };
  }
}

// ---------------- RESPONSE WRAPPER ----------------
class ProductUpdateResponse {
  final String status;
  final String message;
  final ProductData product;
  final ProductDetailData productDetail;
  final InventoryData inventory;

  ProductUpdateResponse({
    required this.status,
    required this.message,
    required this.product,
    required this.productDetail,
    required this.inventory,
  });

  factory ProductUpdateResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return ProductUpdateResponse(
      status: json["status"],
      message: json["message"],
      product: ProductData.fromJson(data["product"]),
      productDetail: ProductDetailData.fromJson(data["product_detail"]),
      inventory: InventoryData.fromJson(data["inventory"]),
    );
  }
}

// ---------------- DROPDOWNS ----------------
class DropdownProductBrand {
  final int id;
  final String name;

  DropdownProductBrand({required this.id, required this.name});

  factory DropdownProductBrand.fromJson(Map<String, dynamic> json) {
    return DropdownProductBrand(
      id: json["id_brand"],
      name: json["brand_name"],
    );
  }
}

class DropdownProductType {
  final int id;
  final String name;

  DropdownProductType({required this.id, required this.name});

  factory DropdownProductType.fromJson(Map<String, dynamic> json) {
    return DropdownProductType(
      id: json["id_product_type"],
      name: json["product_type_name"],
    );
  }
}

class DropdownProductCategory {
  final int id;
  final String name;

  DropdownProductCategory({required this.id, required this.name});

  factory DropdownProductCategory.fromJson(Map<String, dynamic> json) {
    return DropdownProductCategory(
      id: json['id_product_category'],
      name: json['product_category_name'],
    );
  }
}

class DropdownUnitOfMeasure {
  final int id;
  final String name;

  DropdownUnitOfMeasure({required this.id, required this.name});

  factory DropdownUnitOfMeasure.fromJson(Map<String, dynamic> json) {
    return DropdownUnitOfMeasure(
      id: json['id_unit_of_measure'],
      name: json['unit_of_measure_name'],
    );
  }
}
