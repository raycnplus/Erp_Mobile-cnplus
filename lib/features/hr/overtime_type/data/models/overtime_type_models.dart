double _parseDouble(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
}

class OvertimeTypePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  OvertimeTypePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class OvertimeTypeModel {
  final String encryption;
  final String name;
  final String category;
  final double rate;
  final String? description;

  OvertimeTypeModel({
    required this.encryption,
    required this.name,
    required this.category,
    required this.rate,
    this.description,
  });

  factory OvertimeTypeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeTypeModel(
      encryption: json['encryption']?.toString() ?? '',
      name: json['overtime_type_name']?.toString() ?? '',
      category: json['overtime_category']?.toString() ?? '',
      rate: _parseDouble(json['overtime_rate']),
      description: json['overtime_description']?.toString(),
    );
  }
}

class OvertimeTypeDetailModel {
  final OvertimeTypeModel data;
  final String? createdByName;
  final String? updatedByName;
  final String? createdDate;
  final String? updatedDate;

  OvertimeTypeDetailModel({
    required this.data,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
  });

  factory OvertimeTypeDetailModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] ?? json;

    return OvertimeTypeDetailModel(
      data: OvertimeTypeModel.fromJson(dataJson),
      createdByName: dataJson['created_by_name']?.toString(),
      updatedByName: dataJson['updated_by_name']?.toString(),
      createdDate: dataJson['created_date']?.toString(),
      updatedDate: dataJson['updated_date']?.toString(),
    );
  }
}

class OvertimeTypeFormModel {
  String? encryption;
  String name;
  String category;
  double rate;
  String? description;

  OvertimeTypeFormModel({
    this.encryption,
    this.name = '',
    this.category = 'WEEKDAY',
    this.rate = 1.5,
    this.description,
  });

  factory OvertimeTypeFormModel.fromDetail(
    OvertimeTypeDetailModel detail,
  ) {
    return OvertimeTypeFormModel(
      encryption: detail.data.encryption,
      name: detail.data.name,
      category: detail.data.category,
      rate: detail.data.rate,
      description: detail.data.description,
    );
  }

  bool isValid() {
    return name.trim().isNotEmpty && rate > 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'overtime_type_name': name,
      'overtime_category': category,
      'overtime_rate': rate,
      'overtime_description': description,
    };
  }
}

class OvertimeCategoryOption {
  final String value;
  final String label;

  OvertimeCategoryOption({
    required this.value,
    required this.label,
  });

  factory OvertimeCategoryOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return OvertimeCategoryOption(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}