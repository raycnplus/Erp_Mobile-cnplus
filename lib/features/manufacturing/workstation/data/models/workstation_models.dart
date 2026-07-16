class WorkstationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  WorkstationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WorkstationPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return WorkstationPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class WorkstationModel {
  final String encryption;
  final String workstationName;
  final String workstationCode;
  final String? branch;
  final String? address;
  final String? description;

  WorkstationModel({
    required this.encryption,
    required this.workstationName,
    required this.workstationCode,
    this.branch,
    this.address,
    this.description,
  });

  factory WorkstationModel.fromJson(Map<String, dynamic> json) => WorkstationModel(
        encryption: json['encryption']?.toString() ?? '',
        workstationName: json['workstation_name']?.toString() ?? '',
        workstationCode: json['workstation_code']?.toString() ?? '',
        branch: json['branch']?.toString(),
        address: json['address']?.toString(),
        description: json['description']?.toString(),
      );
}

class WorkstationDetailModel {
  final WorkstationData workstation;
  final String? createdByName;
  final String? updatedByName;

  WorkstationDetailModel({
    required this.workstation,
    this.createdByName,
    this.updatedByName,
  });

  factory WorkstationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return WorkstationDetailModel(
      workstation: WorkstationData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class WorkstationData {
  final String encryption;
  final String workstationName;
  final String workstationCode;
  final String? branch;
  final String? address;
  final String? description;
  final double? height;
  final double? length;
  final double? width;
  final double? volume;
  final String? createdDate;
  final String? updatedDate;

  WorkstationData({
    required this.encryption,
    required this.workstationName,
    required this.workstationCode,
    this.branch,
    this.address,
    this.description,
    this.height,
    this.length,
    this.width,
    this.volume,
    this.createdDate,
    this.updatedDate,
  });

  factory WorkstationData.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return WorkstationData(
      encryption: json['encryption']?.toString() ?? '',
      workstationName: json['workstation_name']?.toString() ?? '',
      workstationCode: json['workstation_code']?.toString() ?? '',
      branch: json['branch']?.toString(),
      address: json['address']?.toString(),
      description: json['description']?.toString(),
      height: d(json['height']),
      length: d(json['length']),
      width: d(json['width']),
      volume: d(json['volume']),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class WorkstationFormModel {
  String? encryption;
  String workstationName;
  String workstationCode;
  String? branch;
  String? address;
  String? description;
  double? height;
  double? length;
  double? width;
  double? volume;

  WorkstationFormModel({
    this.encryption,
    this.workstationName = '',
    this.workstationCode = '',
    this.branch,
    this.address,
    this.description,
    this.height,
    this.length,
    this.width,
    this.volume,
  });

  factory WorkstationFormModel.fromDetail(WorkstationDetailModel d) {
    final w = d.workstation;
    return WorkstationFormModel(
      encryption: w.encryption,
      workstationName: w.workstationName,
      workstationCode: w.workstationCode,
      branch: w.branch,
      address: w.address,
      description: w.description,
      height: w.height,
      length: w.length,
      width: w.width,
      volume: w.volume,
    );
  }

  bool isValid() =>
      workstationName.trim().isNotEmpty && workstationCode.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'workstation_name': workstationName,
        'workstation_code': workstationCode,
        if (branch != null && branch!.isNotEmpty) 'branch': branch,
        if (address != null && address!.isNotEmpty) 'address': address,
        if (description != null && description!.isNotEmpty) 'description': description,
        if (height != null) 'height': height,
        if (length != null) 'length': length,
        if (width != null) 'width': width,
        if (volume != null) 'volume': volume,
      };
}