class PositionPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PositionPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PositionPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return PositionPaginationMeta(
      currentPage: data['current_page'] ?? 1,
      lastPage: data['last_page'] ?? 1,
      perPage: data['per_page'] ?? 15,
      total: data['total'] ?? 0,
    );
  }
}

class PositionModel {
  final String encryption;
  final String positionName;
  final String? positionDescription;

  const PositionModel({
    required this.encryption,
    required this.positionName,
    this.positionDescription,
  });

  factory PositionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PositionModel(
      encryption: json['encryption']?.toString() ?? '',
      positionName: json['position_name']?.toString() ?? '',
      positionDescription:
          json['position_description']?.toString(),
    );
  }
}

class PositionDetailModel {
  final PositionData position;
  final String? createdByName;
  final String? updatedByName;

  const PositionDetailModel({
    required this.position,
    this.createdByName,
    this.updatedByName,
  });

  factory PositionDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? json;

    return PositionDetailModel(
      position: PositionData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class PositionData {
  final String encryption;
  final String positionName;
  final String? positionDescription;
  final String? createdDate;
  final String? updatedDate;

  const PositionData({
    required this.encryption,
    required this.positionName,
    this.positionDescription,
    this.createdDate,
    this.updatedDate,
  });

  factory PositionData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PositionData(
      encryption: json['encryption']?.toString() ?? '',
      positionName: json['position_name']?.toString() ?? '',
      positionDescription:
          json['position_description']?.toString(),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class PositionFormModel {
  String? encryption;
  String positionName;
  String positionDescription;

  PositionFormModel({
    this.encryption,
    this.positionName = '',
    this.positionDescription = '',
  });

  factory PositionFormModel.fromDetail(
    PositionDetailModel detail,
  ) {
    return PositionFormModel(
      encryption: detail.position.encryption,
      positionName: detail.position.positionName,
      positionDescription:
          detail.position.positionDescription ?? '',
    );
  }

  bool get isValid => positionName.trim().isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'position_name': positionName,
      'position_description':
          positionDescription.isEmpty
              ? null
              : positionDescription,
    };
  }
}