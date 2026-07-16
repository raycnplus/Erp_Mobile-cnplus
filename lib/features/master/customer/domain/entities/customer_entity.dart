class CustomerEntity {
  final int id;
  final String name;
  final String code;
  final String email;
  final String phoneNo;
  final String? city;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.email,
    required this.phoneNo,
    this.city,
  });
}