class ProductModel {
  final int idProduct;
  final String productName;
  final String productCode;
  final double? salesPrice;
  final double? purchasePrice;
  final int onHand;
  final bool sales;
  final bool purchase;
  final bool pointOfSale;
  final bool directPurchase;
  final bool expense;
  final String? barcode;
  final ProductDetailModel? detail;
  final InventoryModel? inventory;

  ProductModel({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    this.salesPrice,
    this.purchasePrice,
    required this.onHand,
    this.sales = true,
    this.purchase = true,
    this.pointOfSale = true,
    this.directPurchase = true,
    this.expense = true,
    this.barcode,
    this.detail,
    this.inventory,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduct: json['id_product'],
      productName: json['product_name'],
      productCode: json['product_code'],
      salesPrice: json['sales_price'] != null
          ? double.tryParse(json['sales_price'].toString())
          : null,
      purchasePrice: json['purchase_price'] != null
          ? double.tryParse(json['purchase_price'].toString())
          : null,
      onHand: json['on_hand'] ?? 0,
      sales: json['sales'] ?? true,
      purchase: json['purchase'] ?? true,
      pointOfSale: json['point_of_sale'] ?? true,
      directPurchase: json['direct_purchase'] ?? true,
      expense: json['expense'] ?? true,
      barcode: json['barcode'],
      detail: json['product_detail'] != null
          ? ProductDetailModel.fromJson(json['product_detail'])
          : null,
      inventory: json['inventory'] != null
          ? InventoryModel.fromJson(json['inventory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_code': productCode,
      'sales': sales,
      'purchase': purchase,
      'point_of_sale': pointOfSale,
      'direct_purchase': directPurchase,
      'expense': expense,
      'barcode': barcode,
      if (detail != null) 'product_detail': detail!.toJson(),
      if (inventory != null) 'inventory': inventory!.toJson(),
    };
  }
}

class ProductDetailModel {
  final int? productType;
  final int? productCategory;
  final int? productBrand;
  final int? unitOfMeasure;
  final double? salesPrice;
  final double? purchasePrice;
  final String? barcode;
  final String? noteDetail;

  ProductDetailModel({
    this.productType,
    this.productCategory,
    this.productBrand,
    this.unitOfMeasure,
    this.salesPrice,
    this.purchasePrice,
    this.barcode,
    this.noteDetail,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productType: json['product_type'],
      productCategory: json['product_category'],
      productBrand: json['product_brand'],
      unitOfMeasure: json['unit_of_measure'],
      salesPrice: (json['sales_price'] ?? 0).toDouble(),
      purchasePrice: (json['purchase_price'] ?? 0).toDouble(),
      barcode: json['barcode'],
      noteDetail: json['note_detail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_type': productType,
      'product_category': productCategory,
      'product_brand': productBrand,
      'unit_of_measure': unitOfMeasure,
      'sales_price': salesPrice,
      'purchase_price': purchasePrice,
      'barcode': barcode,
      'note_detail': noteDetail,
    };
  }
}

class InventoryModel {
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final double? volume;
  final String? noteInventory;
  final bool tracking;
  final String? trackingMethod;

  InventoryModel({
    this.weight,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.noteInventory,
    this.tracking = false,
    this.trackingMethod,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      weight: (json['weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      volume: (json['volume'] ?? 0).toDouble(),
      noteInventory: json['note_inventory'],
      tracking: json['tracking'] ?? false,
      trackingMethod: json['tracking_method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'volume': volume,
      'note_inventory': noteInventory,
      'tracking': tracking,
      'tracking_method': trackingMethod,
    };
  }
}