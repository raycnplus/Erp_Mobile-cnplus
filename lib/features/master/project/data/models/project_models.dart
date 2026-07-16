class ProjectPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  ProjectPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ProjectPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return ProjectPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class ProjectModel {
  final String encryption;
  final String projectCode;
  final String projectName;
  final String? startDate;
  final String? endDate;
  final String customer;
  final String manager;

  ProjectModel({
    required this.encryption,
    required this.projectCode,
    required this.projectName,
    this.startDate,
    this.endDate,
    this.customer = '-',
    this.manager = '-',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    encryption: json['encryption']?.toString() ?? '',
    projectCode: json['project_code']?.toString() ?? '',
    projectName: json['project_name']?.toString() ?? '',
    startDate: json['start_date']?.toString(),
    endDate: json['end_date']?.toString(),
    customer: json['customer']?.toString() ?? '-',
    manager: json['manager']?.toString() ?? '-',
  );
}

class ProjectDetailModel {
  final ProjectData project;
  final String? createdByName;
  final String? updatedByName;

  ProjectDetailModel({
    required this.project,
    this.createdByName,
    this.updatedByName,
  });

  factory ProjectDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ProjectDetailModel(
      project: ProjectData.fromJson(data),
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class ProjectData {
  final String encryption;
  final String projectCode;
  final String projectName;
  final String? startDate;
  final String? endDate;
  final int? customerId;
  final int? projectManagerId;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  ProjectData({
    required this.encryption,
    required this.projectCode,
    required this.projectName,
    this.startDate,
    this.endDate,
    this.customerId,
    this.projectManagerId,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
    encryption: json['encryption']?.toString() ?? '',
    projectCode: json['project_code']?.toString() ?? '',
    projectName: json['project_name']?.toString() ?? '',
    startDate: json['start_date']?.toString(),
    endDate: json['end_date']?.toString(),
    customerId: json['customer_id'] is int
        ? json['customer_id']
        : int.tryParse(json['customer_id']?.toString() ?? ''),
    projectManagerId: json['project_manager_id'] is int
        ? json['project_manager_id']
        : int.tryParse(json['project_manager_id']?.toString() ?? ''),
    description: json['description']?.toString(),
    createdDate: json['created_date']?.toString(),
    updatedDate: json['updated_date']?.toString(),
  );
}

class ProjectCustomerOption {
  final int id;
  final String name;

  ProjectCustomerOption({required this.id, required this.name});

  factory ProjectCustomerOption.fromJson(Map<String, dynamic> json) => ProjectCustomerOption(
    id: json['id_customer'] is int
        ? json['id_customer']
        : int.tryParse(json['id_customer']?.toString() ?? '0') ?? 0,
    name: json['customer_name']?.toString() ?? '',
  );

  @override
  bool operator ==(Object o) => o is ProjectCustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ProjectUserOption {
  final int id;
  final String name;

  ProjectUserOption({required this.id, required this.name});

  factory ProjectUserOption.fromJson(Map<String, dynamic> json) => ProjectUserOption(
    id: json['id_user'] is int
        ? json['id_user']
        : int.tryParse(json['id_user']?.toString() ?? '0') ?? 0,
    name: json['nama_lengkap']?.toString() ?? '',
  );

  @override
  bool operator ==(Object o) => o is ProjectUserOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ProjectFormOptions {
  final List<ProjectCustomerOption> customers;
  final List<ProjectUserOption> users;
  final String? defaultCode;

  ProjectFormOptions({
    required this.customers,
    required this.users,
    this.defaultCode,
  });

  factory ProjectFormOptions.fromJson(Map<String, dynamic> json) => ProjectFormOptions(
    customers: (json['customers'] as List? ?? []).map((e) => ProjectCustomerOption.fromJson(e)).toList(),
    users: (json['users'] as List? ?? []).map((e) => ProjectUserOption.fromJson(e)).toList(),
    defaultCode: json['default_code']?.toString(),
  );
}

class ProjectFormModel {
  String? encryption;
  String projectName;
  int? customerId;
  int? projectManagerId;
  String? startDate;
  String? endDate;
  String? description;

  ProjectFormModel({
    this.encryption,
    this.projectName = '',
    this.customerId,
    this.projectManagerId,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory ProjectFormModel.fromDetail(ProjectDetailModel detail) {
    final d = detail.project;
    return ProjectFormModel(
      encryption: d.encryption,
      projectName: d.projectName,
      customerId: d.customerId,
      projectManagerId: d.projectManagerId,
      startDate: d.startDate,
      endDate: d.endDate,
      description: d.description,
    );
  }

  bool isValid() => projectName.trim().isNotEmpty && projectManagerId != null && startDate != null;

  Map<String, dynamic> toJson() => {
    'project_name': projectName,
    if (customerId != null) 'customer_id': customerId,
    'project_manager_id': projectManagerId,
    'start_date': startDate,
    if (endDate != null) 'end_date': endDate,
    if (description != null && description!.isNotEmpty) 'description': description,
  };
}