// show_product_models.dart

class ProductShowResponse {
  final Map<String, dynamic> rawData;

  ProductShowResponse({
    required this.rawData,
  });

  factory ProductShowResponse.fromJson(Map<String, dynamic> json) {
    return ProductShowResponse(
      rawData: json["data"] ?? {},
    );
  }

  Map<String, dynamic> get product => rawData["product"] ?? {};
  Map<String, dynamic> get productDetail => rawData["product_detail"] ?? {};
  Map<String, dynamic> get inventory => rawData["inventory"] ?? {};
  
  // Getter ini aman karena 'String?' (nullable)
  String? get createdByName => rawData["created_by_name"];
  
  // Product getters
  int get idProduct => product["id_product"] ?? 0;
  
  // [PERBAIKAN] Pastikan semua 'String' (non-nullable) punya nilai default '??'
  String get productCode => product["product_code"] ?? '';
  String get productName => product["product_name"] ?? '';
  String get createdDate => product["created_date"] ?? '';

  // [AMAN] Ini 'String?' (nullable), sudah benar
  String? get barcode => product["barcode"];
  int get createdBy => product["created_by"] ?? 0;
  
  // Product Detail getters
  int get idProductDetail => productDetail["id_product_detail"] ?? 0;
  
  // [AMAN] Ini 'double?' (nullable), sudah benar
  double? get salesPrice => productDetail["sales_price"] != null 
      ? double.tryParse(productDetail["sales_price"].toString())
      : null;
  double? get costPrice => productDetail["cost_price"] != null 
      ? double.tryParse(productDetail["cost_price"].toString())
      : null;
      
  // [AMAN] Ini 'String?' (nullable), sudah benar
  String? get detailBarcode => productDetail["barcode"];
  
  // [AMAN] Ini 'int?' (nullable), sudah benar
  int? get productType => productDetail["product_type"];
  int? get productCategory => productDetail["product_category"];
  
  // [AMAN] Ini 'String?' (nullable), sudah benar
  String? get productBrand => productDetail["product_brand"]?.toString();
  String? get noteDetail => productDetail["note_detail"];

  // [PERBAIKAN] Pastikan 'String' (non-nullable) punya nilai default '??'
  String get unitOfMeasureName => productDetail["unit_of_measure_name"] ?? '';
  
  // Inventory getters
  int get idInventory => inventory["id_inventory"] ?? 0;
  
  // [AMAN] Ini 'String?' (nullable), sudah benar
  String? get weight => inventory["weight"]?.toString();
  String? get length => inventory["length"]?.toString();
  String? get width => inventory["width"]?.toString();
  String? get height => inventory["height"]?.toString();
  String? get volume => inventory["volume"]?.toString();
  String? get noteInventory => inventory["note_inventory"];
  String? get trackingMethod => inventory["tracking_method"]; // Sangat penting, karena di JSON nilainya null

  // [PERBAIKAN] Pastikan 'String' (non-nullable) punya nilai default '??'
  String get inventoryCreatedDate => inventory["created_date"] ?? '';
  
  // [AMAN] Ini 'int?' (nullable), sudah benar
  int get inventoryCreatedBy => inventory["created_by"] ?? 0;
  int? get tracking => inventory["tracking"];
}


/* ===================================================================
  CATATAN: Kelas-kelas di bawah ini (Product, ProductDetail, Inventory)
  TIDAK DIGUNAKAN oleh 'ProductShowWidget' kamu. 
  Widget kamu hanya menggunakan 'ProductShowResponse'. 
  Jadi error-nya pasti ada di kelas 'ProductShowResponse' di atas.
  Namun, saya biarkan saja definisi kelas ini di sini.
===================================================================
*/

class Product {
  final int idProduct;
  final String productCode;
  final String productName;
  final String? barcode;
  final String? barcodeAsli;
  final String? idCategory;
  final String? idJenisBarang;
  final String? idMerk;
  final String? satuan;
  final int? sales;
  final int? purchase;
  final String createdDate;
  final int createdBy;

  Product({
    required this.idProduct,
    required this.productCode,
    required this.productName,
    this.barcode,
    this.barcodeAsli,
    this.idCategory,
    this.idJenisBarang,
    this.idMerk,
    this.satuan,
    this.sales,
    this.purchase,
    required this.createdDate,
    required this.createdBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        idProduct: json["id_product"] ?? 0,
        productCode: json["product_code"] ?? '',
        productName: json["product_name"] ?? '',
        barcode: json["barcode"],
        barcodeAsli: json["barcode_asli"],
        idCategory: json["id_category"]?.toString(),
        idJenisBarang: json["id_jenis_barang"]?.toString(),
        idMerk: json["id_merk"]?.toString(),
        satuan: json["satuan"]?.toString(),
        sales: json["sales"],
        purchase: json["purchase"],
        createdDate: json["created_date"] ?? '',
        createdBy: json["created_by"] ?? 0,
      );
}

class ProductDetail {
  final int idProductDetail;
  final double? salesPrice;
  final double? costPrice;
  final double? purchasePrice;
  final String? barcode;
  final int? unitOfMeasure;
  final int? productType;
  final int? productBrand;
  final int? productCategory;
  final String? tiktokCategory;
  final String? shopeeCategory;
  final String? noteDetail;
  final String unitOfMeasureName;

  ProductDetail({
    required this.idProductDetail,
    this.salesPrice,
    this.costPrice,
    this.purchasePrice,
    this.barcode,
    this.unitOfMeasure,
    this.productType,
    this.productBrand,
    this.productCategory,
    this.tiktokCategory,
    this.shopeeCategory,
    this.noteDetail,
    required this.unitOfMeasureName,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        idProductDetail: json["id_product_detail"] ?? 0,
        salesPrice: json["sales_price"] != null 
            ? double.tryParse(json["sales_price"].toString())
            : null,
        costPrice: json["cost_price"] != null 
            ? double.tryParse(json["cost_price"].toString())
            : null,
        purchasePrice: json["purchase_price"] != null 
            ? double.tryParse(json["purchase_price"].toString())
            : null,
        barcode: json["barcode"],
        unitOfMeasure: json["unit_of_measure"],
        productType: json["product_type"],
        productBrand: json["product_brand"],
        productCategory: json["product_category"],
        tiktokCategory: json["tiktok_category"],
        shopeeCategory: json["shopee_category"],
        noteDetail: json["note_detail"],
        unitOfMeasureName: json["unit_of_measure_name"] ?? '',
      );
}

class Inventory {
  final int idInventory;
  final String? weight;
  final String? length;
  final String? width;
  final String? height;
  final String? volume;
  final int? tracking;
  final String? trackingMethod;
  final String? noteInventory;
  final String createdDate;
  final int createdBy;
  final String? updatedDate;
  final int? updatedBy;

  Inventory({
    required this.idInventory,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.tracking,
    this.trackingMethod,
    this.noteInventory,
    required this.createdDate,
    required this.createdBy,
    this.updatedDate,
    this.updatedBy,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        idInventory: json["id_inventory"] ?? 0,
        weight: json["weight"]?.toString(),
        length: json["length"]?.toString(),
        width: json["width"]?.toString(),
        height: json["height"]?.toString(),
        volume: json["volume"]?.toString(),
        tracking: json["tracking"],
        trackingMethod: json["tracking_method"],
        noteInventory: json["note_inventory"],
        createdDate: json["created_date"] ?? '',
        createdBy: json["created_by"] ?? 0,
        updatedDate: json["updated_date"],
        updatedBy: json["updated_by"],
      );
}