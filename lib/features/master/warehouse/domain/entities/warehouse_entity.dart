class WarehouseEntity {
  final int id;
  final String name;
  final String code;
  final String? branch;
  final int? stockOnHand;

  WarehouseEntity({
    required this.id,
    required this.name,
    required this.code,
    this.branch,
    this.stockOnHand,
  });
}