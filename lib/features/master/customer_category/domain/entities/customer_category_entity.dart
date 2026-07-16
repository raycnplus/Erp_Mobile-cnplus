class CustomerCategoryEntity {
  final int id;
  final String name;
  final String code;
  final String? description;

  CustomerCategoryEntity({
    required this.id,
    required this.name,
    required this.code,
    this.description,
  });
}