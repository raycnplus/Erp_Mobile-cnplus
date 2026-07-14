class CollectiveLeavePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const CollectiveLeavePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CollectiveLeavePaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return CollectiveLeavePaginationMeta(
      currentPage: data['current_page'] ?? 1,
      lastPage: data['last_page'] ?? 1,
      perPage: data['per_page'] ?? 15,
      total: data['total'] ?? 0,
    );
  }
}

class CollectiveLeaveModel {
  final String encryption;
  final String collectiveLeaveName;
  final String fromDate;
  final String toDate;
  final int? duration;

  const CollectiveLeaveModel({
    required this.encryption,
    required this.collectiveLeaveName,
    required this.fromDate,
    required this.toDate,
    this.duration,
  });

  factory CollectiveLeaveModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CollectiveLeaveModel(
      encryption: json['encryption']?.toString() ?? '',
      collectiveLeaveName:
          json['collective_leave_name']?.toString() ?? '',
      fromDate:
          json['from_date_formatted']?.toString() ??
          json['from_date']?.toString() ??
          '',
      toDate:
          json['to_date_formatted']?.toString() ??
          json['to_date']?.toString() ??
          '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(
              json['duration']?.toString() ?? '',
            ),
    );
  }
}

class CollectiveLeaveDetailModel {
  final CollectiveLeaveData collectiveLeave;
  final String? createdByName;
  final String? updatedByName;

  const CollectiveLeaveDetailModel({
    required this.collectiveLeave,
    this.createdByName,
    this.updatedByName,
  });

  factory CollectiveLeaveDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? json;

    return CollectiveLeaveDetailModel(
      collectiveLeave: CollectiveLeaveData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class CollectiveLeaveData {
  final String encryption;
  final String collectiveLeaveName;
  final String fromDate;
  final String toDate;
  final int? duration;
  final String? createdDate;
  final String? updatedDate;

  const CollectiveLeaveData({
    required this.encryption,
    required this.collectiveLeaveName,
    required this.fromDate,
    required this.toDate,
    this.duration,
    this.createdDate,
    this.updatedDate,
  });

  factory CollectiveLeaveData.fromJson(
    Map<String, dynamic> json,
  ) {
    return CollectiveLeaveData(
      encryption: json['encryption']?.toString() ?? '',
      collectiveLeaveName:
          json['collective_leave_name']?.toString() ?? '',
      fromDate: json['from_date']?.toString() ?? '',
      toDate: json['to_date']?.toString() ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(
              json['duration']?.toString() ?? '',
            ),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class CollectiveLeaveFormModel {
  String? encryption;
  String collectiveLeaveName;
  String fromDate;
  String toDate;

  CollectiveLeaveFormModel({
    this.encryption,
    this.collectiveLeaveName = '',
    this.fromDate = '',
    this.toDate = '',
  });

  factory CollectiveLeaveFormModel.fromDetail(
    CollectiveLeaveDetailModel detail,
  ) {
    final collectiveLeave = detail.collectiveLeave;

    return CollectiveLeaveFormModel(
      encryption: collectiveLeave.encryption,
      collectiveLeaveName:
          collectiveLeave.collectiveLeaveName,
      fromDate: collectiveLeave.fromDate,
      toDate: collectiveLeave.toDate,
    );
  }

  bool get isValid {
    return collectiveLeaveName.trim().isNotEmpty &&
        fromDate.isNotEmpty &&
        toDate.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'collective_leave_name': collectiveLeaveName,
      'from_date': fromDate,
      'to_date': toDate,
    };
  }
}