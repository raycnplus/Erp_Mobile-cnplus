class ProductIndexModel {
  final int idProduct;
  final String productName;
  final String productCode;
  final double? salesPrice;
  final double? purchasePrice;
  final int onHand;

  ProductIndexModel({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    this.salesPrice,
    this.purchasePrice,
    required this.onHand,
  });

  factory ProductIndexModel.fromJson(Map<String, dynamic> json) {
    return ProductIndexModel(
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
    );
  }
}
