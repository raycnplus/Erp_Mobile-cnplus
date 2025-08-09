class TopProduct {
  final String name;
  final int count;
  final quantity;

  TopProduct({
    required this.name,
    required this.count,
    required this.quantity,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      name: json['name'] ?? json['label'],
      count: json['count'] ?? json['value'],
      quantity: json['quantity']
    );
  }

  static List<TopProduct> fromList(dynamic raw) {
    final List<dynamic> list = raw is List ? raw : raw['data'];
    return list
        .map((e) => TopProduct.fromJson(e))
        .take(5) // ambil hanya 5 teratas
        .toList();
  }
}