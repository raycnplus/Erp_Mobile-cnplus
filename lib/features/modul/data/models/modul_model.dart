class ModulModel {
  final String key;
  final String name;
  final String subtitle;

  ModulModel ({
    required this.key,
    required this.name,
    required this.subtitle
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      key: json['key'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}