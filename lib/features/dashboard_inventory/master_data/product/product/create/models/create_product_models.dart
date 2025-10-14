import 'package:flutter/material.dart';

// ---------------- PRODUCT DETAIL ----------------
class ProductDetailData {
  final int productType;
  final int productCategory;
  final int? productBrand; 
  final int unitOfMeasure;
  final double salesPrice;
  final double purchasePrice;
  final String barcode;
  final String noteDetail;

  ProductDetailData({
    required this.productType,
    required this.productCategory,
    this.productBrand,
    required this.unitOfMeasure,
    required this.salesPrice,
    required this.purchasePrice,
    required this.barcode,
    required this.noteDetail,
  });

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

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      productType: json["product_type"],
      productCategory: json["product_category"],
      productBrand: json["product_brand"],
      unitOfMeasure: json["unit_of_measure"],
      salesPrice: (json["sales_price"] as num).toDouble(),
      purchasePrice: (json["purchase_price"] as num).toDouble(),
      barcode: json["barcode"],
      noteDetail: json["note_detail"],
    );
  }
}

// ---------------- INVENTORY ----------------
class InventoryData {
  final double weight;
  final double length;
  final double width;
  final double height;
  final double volume;
  final String noteInventory;
  final bool tracking;
  final String? trackingMethod;

  InventoryData({
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.volume,
    required this.noteInventory,
    required this.tracking,
    this.trackingMethod,
  });

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

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      weight: (json["weight"] as num).toDouble(),
      length: (json["length"] as num).toDouble(),
      width: (json["width"] as num).toDouble(),
      height: (json["height"] as num).toDouble(),
      volume: (json["volume"] as num).toDouble(),
      noteInventory: json["note_inventory"],
      tracking: json["tracking"],
      trackingMethod: json["tracking_method"],
    );
  }
}

// ---------------- RESPONSE WRAPPER ----------------
class ProductCreateResponse {
  final String status;
  final String message;
  final ProductDetailData productDetail;
  final InventoryData inventory;

  ProductCreateResponse({
    required this.status,
    required this.message,
    required this.productDetail,
    required this.inventory,
  });

  factory ProductCreateResponse.fromJson(Map<String, dynamic> json) {
    return ProductCreateResponse(
      status: json["status"],
      message: json["message"],
      productDetail: ProductDetailData.fromJson(json["data"]["product_detail"]),
      inventory: InventoryData.fromJson(json["data"]["inventory"]),
    );
  }
}


// ---------------- DROPDOWNS ----------------
class DropdownProductBrand {
  final int id;
  final String name;

  DropdownProductBrand({required this.id, required this.name});

  // Kode ini sudah dikoreksi sesuai JSON response
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