class ProductShowResponse {
  final Product product;
  final ProductDetail productDetail;
  final Inventory inventory;
  final String? createdByName;

  ProductShowResponse({
    required this.product,
    required this.productDetail,
    required this.inventory,
    this.createdByName,
  });

  factory ProductShowResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return ProductShowResponse(
      product: Product.fromJson(data["product"]),
      productDetail: ProductDetail.fromJson(data["product_detail"]),
      inventory: Inventory.fromJson(data["inventory"]),
      createdByName: data["created_by_name"],
    );
  }
}

class Product {
  final int idProduct;
  final String productCode;
  final String productName;
  final String? barcode;
  final String createdDate;
  final int createdBy;

  Product({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    this.barcode,
    required this.createdDate,
    required this.createdBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        idProduct: json["id_product"],
        productCode: json["product_code"],
        productName: json["product_name"],
        barcode: json["barcode"],
        createdDate: json["created_date"],
        createdBy: json["created_by"],
      );
}

class ProductDetail {
  final int idProductDetail;
  final double salesPrice;
  final double? costPrice;
  final String barcode;
  final int productType;
  final int? productCategory;
  final String? productBrand;
  final String unitOfMeasureName;
  final String? noteDetail;

  ProductDetail({
    required this.idProductDetail,
    required this.salesPrice,
    this.costPrice,
    required this.barcode,
    required this.productType,
    this.productCategory,
    this.productBrand,
    required this.unitOfMeasureName,
    this.noteDetail,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        idProductDetail: json["id_product_detail"],
        salesPrice: (json["sales_price"] ?? 0).toDouble(),
        costPrice:
            json["cost_price"] != null ? (json["cost_price"]).toDouble() : null,
        barcode: json["barcode"],
        productType: json["product_type"],
        productCategory: json["product_category"],
        productBrand: json["product_brand"],
        unitOfMeasureName: json["unit_of_measure_name"],
        noteDetail: json["note_detail"],
      );
}

class Inventory {
  final int idInventory;
  final String weight;
  final String length;
  final String width;
  final String height;
  final String volume;
  final String createdDate;
  final int createdBy;
  final String? noteInventory;
  final int? tracking;
  final String? trackingMethod;

  Inventory({
    required this.idInventory,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.volume,
    required this.createdDate,
    required this.createdBy,
    this.noteInventory,
    this.tracking,
    this.trackingMethod,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        idInventory: json["id_inventory"],
        weight: json["weight"],
        length: json["length"],
        width: json["width"],
        height: json["height"],
        volume: json["volume"],
        createdDate: json["created_date"],
        createdBy: json["created_by"],
        noteInventory: json["note_inventory"],
        tracking: json["tracking"],
        trackingMethod: json["tracking_method"],
      );
}
