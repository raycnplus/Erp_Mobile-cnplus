double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

class UomPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  UomPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory UomPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final m = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;

    return UomPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class UomModel {
  final String encryption;
  final String uomName;
  final double quantity;
  final int? referenceUnit;
  final String? referenceUnitName;

  UomModel({
    required this.encryption,
    required this.uomName,
    required this.quantity,
    this.referenceUnit,
    this.referenceUnitName,
  });

  factory UomModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UomModel(
      encryption: json['encryption']?.toString() ?? '',
      uomName: json['unit_of_measure_name']?.toString() ?? '',
      quantity: _pd(json['quantity']),
      referenceUnit: _pi(json['reference_unit']) == 0
          ? null
          : _pi(json['reference_unit']),
      referenceUnitName: json['reference_unit_name']?.toString(),
    );
  }
}

class UomDetailModel {
  final UomData uom;
  final List<UomRefOption> referenceUnits;
  final String? createdByName;
  final String? updatedByName;

  UomDetailModel({
    required this.uom,
    required this.referenceUnits,
    this.createdByName,
    this.updatedByName,
  });

  factory UomDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UomDetailModel(
      uom: UomData.fromJson(
        json['data'] ?? json,
      ),
      referenceUnits:
          (json['reference_units'] as List? ?? [])
              .map(
                (e) => UomRefOption.fromJson(e),
              )
              .toList(),
      createdByName:
          json['created_by_name']?.toString(),
      updatedByName:
          json['updated_by_name']?.toString(),
    );
  }
}

class UomData {
  final String encryption;
  final String uomName;
  final double quantity;
  final int? referenceUnit;
  final String? referenceUnitName;
  final String? createdDate;
  final String? updatedDate;

  UomData({
    required this.encryption,
    required this.uomName,
    required this.quantity,
    this.referenceUnit,
    this.referenceUnitName,
    this.createdDate,
    this.updatedDate,
  });

  factory UomData.fromJson(
    Map<String, dynamic> json,
  ) {
    return UomData(
      encryption: json['encryption']?.toString() ?? '',
      uomName: json['unit_of_measure_name']?.toString() ?? '',
      quantity: _pd(json['quantity']),
      referenceUnit: _pi(json['reference_unit']) == 0
          ? null
          : _pi(json['reference_unit']),
      referenceUnitName:
          json['reference_unit_name']?.toString(),
      createdDate:
          json['created_date']?.toString(),
      updatedDate:
          json['updated_date']?.toString(),
    );
  }
}

class UomRefOption {
  final int id;
  final String name;
  final double quantity;

  UomRefOption({
    required this.id,
    required this.name,
    required this.quantity,
  });

  factory UomRefOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return UomRefOption(
      id: _pi(json['id_unit_of_measure']),
      name: json['unit_of_measure_name']?.toString() ?? '',
      quantity: _pd(json['quantity']),
    );
  }

  @override
  bool operator ==(Object o) {
    return o is UomRefOption && o.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UomFormModel {
  String? encryption;
  String uomName;
  double quantity;
  int? referenceUnit;

  UomFormModel({
    this.encryption,
    this.uomName = '',
    this.quantity = 1,
    this.referenceUnit,
  });

  factory UomFormModel.fromDetail(
    UomDetailModel d,
  ) {
    return UomFormModel(
      encryption: d.uom.encryption,
      uomName: d.uom.uomName,
      quantity: d.uom.quantity,
      referenceUnit: d.uom.referenceUnit,
    );
  }

  bool isValid() {
    return uomName.trim().isNotEmpty &&
        quantity > 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'unit_of_measure_name': uomName,
      'quantity': quantity,
      if (referenceUnit != null)
        'reference_unit': referenceUnit,
    };
  }
}