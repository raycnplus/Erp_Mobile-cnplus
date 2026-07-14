class EmployeeStatusPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const EmployeeStatusPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory EmployeeStatusPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final meta =
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    return EmployeeStatusPaginationMeta(
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class EmployeeStatusModel {
  final String encryption;
  final String employeeStatusName;
  final String isActive;

  const EmployeeStatusModel({
    required this.encryption,
    required this.employeeStatusName,
    required this.isActive,
  });

  factory EmployeeStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmployeeStatusModel(
      encryption: json['encryption']?.toString() ?? '',
      employeeStatusName:
          json['employee_status_name']?.toString() ?? '',
      isActive: json['is_active']?.toString() ?? 'Y',
    );
  }
}

class EmployeeStatusDetailModel {
  final EmployeeStatusData status;
  final String? createdByName;
  final String? updatedByName;

  const EmployeeStatusDetailModel({
    required this.status,
    this.createdByName,
    this.updatedByName,
  });

  factory EmployeeStatusDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data =
        (json['data'] as Map<String, dynamic>?) ?? json;

    return EmployeeStatusDetailModel(
      status: EmployeeStatusData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class EmployeeStatusData {
  final String encryption;
  final String employeeStatusName;
  final String isActive;
  final String? createdDate;
  final String? updatedDate;

  const EmployeeStatusData({
    required this.encryption,
    required this.employeeStatusName,
    required this.isActive,
    this.createdDate,
    this.updatedDate,
  });

  factory EmployeeStatusData.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmployeeStatusData(
      encryption: json['encryption']?.toString() ?? '',
      employeeStatusName:
          json['employee_status_name']?.toString() ?? '',
      isActive: json['is_active']?.toString() ?? 'Y',
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class EmployeeStatusFormModel {
  String? encryption;
  String employeeStatusName;
  String isActive;
  String? createdDate;
  String? updatedDate;

  EmployeeStatusFormModel({
    this.encryption,
    this.employeeStatusName = '',
    this.isActive = 'Y',
    this.createdDate,
    this.updatedDate,
  });

  factory EmployeeStatusFormModel.fromDetail(
    EmployeeStatusDetailModel detail,
  ) {
    return EmployeeStatusFormModel(
      encryption: detail.status.encryption,
      employeeStatusName: detail.status.employeeStatusName,
      isActive: detail.status.isActive,
      createdDate: detail.status.createdDate,
      updatedDate: detail.status.updatedDate,
    );
  }

  bool isValid() {
    return employeeStatusName.trim().isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_status_name': employeeStatusName,
      'is_active': isActive,
    };
  }
}