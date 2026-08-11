class ProductEntity {
  final int id;
  final String name;
  final String code;
  final double? salesPrice;
  final double? purchasePrice;
  final int stockOnHand;

  ProductEntity({
    required this.id,
    required this.name,
    required this.code,
    this.salesPrice,
    this.purchasePrice,
    required this.stockOnHand,
  });
}