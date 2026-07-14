class DepartmentPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const DepartmentPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory DepartmentPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final meta =
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    return DepartmentPaginationMeta(
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class DepartmentModel {
  final String encryption;
  final String departmentName;
  final String? departmentDescription;

  const DepartmentModel({
    required this.encryption,
    required this.departmentName,
    this.departmentDescription,
  });

  factory DepartmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DepartmentModel(
      encryption: json['encryption']?.toString() ?? '',
      departmentName: json['department_name']?.toString() ?? '',
      departmentDescription:
          json['department_description']?.toString(),
    );
  }
}

class DepartmentDetailModel {
  final DepartmentData department;
  final String? createdByName;
  final String? updatedByName;

  const DepartmentDetailModel({
    required this.department,
    this.createdByName,
    this.updatedByName,
  });

  factory DepartmentDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data =
        (json['data'] as Map<String, dynamic>?) ?? json;

    return DepartmentDetailModel(
      department: DepartmentData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class DepartmentData {
  final String encryption;
  final String departmentName;
  final String? departmentDescription;
  final String? createdDate;
  final String? updatedDate;

  const DepartmentData({
    required this.encryption,
    required this.departmentName,
    this.departmentDescription,
    this.createdDate,
    this.updatedDate,
  });

  factory DepartmentData.fromJson(
    Map<String, dynamic> json,
  ) {
    return DepartmentData(
      encryption: json['encryption']?.toString() ?? '',
      departmentName: json['department_name']?.toString() ?? '',
      departmentDescription:
          json['department_description']?.toString(),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class DepartmentFormModel {
  String? encryption;
  String departmentName;
  String departmentDescription;
  String? createdDate;
  String? updatedDate;

  DepartmentFormModel({
    this.encryption,
    this.departmentName = '',
    this.departmentDescription = '',
    this.createdDate,
    this.updatedDate,
  });

  factory DepartmentFormModel.fromDetail(
    DepartmentDetailModel detail,
  ) {
    return DepartmentFormModel(
      encryption: detail.department.encryption,
      departmentName: detail.department.departmentName,
      departmentDescription:
          detail.department.departmentDescription ?? '',
      createdDate: detail.department.createdDate,
      updatedDate: detail.department.updatedDate,
    );
  }

  bool isValid() {
    return departmentName.trim().isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'department_name': departmentName,
      'department_description':
          departmentDescription.isEmpty
              ? null
              : departmentDescription,
    };
  }
}