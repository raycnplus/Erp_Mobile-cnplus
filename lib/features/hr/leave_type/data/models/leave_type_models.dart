class LeaveTypePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const LeaveTypePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LeaveTypePaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return LeaveTypePaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class LeaveTypeModel {
  final String encryption;
  final String leaveTypeName;
  final String? leaveCategory;
  final String? leaveDescription;

  const LeaveTypeModel({
    required this.encryption,
    required this.leaveTypeName,
    this.leaveCategory,
    this.leaveDescription,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      encryption: json['encryption']?.toString() ?? '',
      leaveTypeName: json['leave_type_name']?.toString() ?? '',
      leaveCategory: json['leave_category']?.toString(),
      leaveDescription: json['leave_description']?.toString(),
    );
  }
}

class LeaveTypeDetailModel {
  final LeaveTypeData leaveType;
  final String? createdByName;
  final String? updatedByName;

  const LeaveTypeDetailModel({
    required this.leaveType,
    this.createdByName,
    this.updatedByName,
  });

  factory LeaveTypeDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LeaveTypeDetailModel(
      leaveType: LeaveTypeData.fromJson(data as Map<String, dynamic>),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class LeaveTypeData {
  final String encryption;
  final String leaveTypeName;
  final String? leaveCategory;
  final String? leaveDescription;
  final bool deductBalance;
  final String? allocationMethod;
  final bool carryOver;
  final bool allowHalfDay;
  final String? requiredAttachment;
  final String? createdDate;
  final String? updatedDate;

  const LeaveTypeData({
    required this.encryption,
    required this.leaveTypeName,
    this.leaveCategory,
    this.leaveDescription,
    this.deductBalance = false,
    this.allocationMethod,
    this.carryOver = false,
    this.allowHalfDay = false,
    this.requiredAttachment,
    this.createdDate,
    this.updatedDate,
  });

  factory LeaveTypeData.fromJson(Map<String, dynamic> json) {
    return LeaveTypeData(
      encryption: json['encryption']?.toString() ?? '',
      leaveTypeName: json['leave_type_name']?.toString() ?? '',
      leaveCategory: json['leave_category']?.toString(),
      leaveDescription: json['leave_description']?.toString(),
      deductBalance: _parseBool(json['deduct_balance']),
      allocationMethod: json['allocation_method']?.toString(),
      carryOver: _parseBool(json['carry_over']),
      allowHalfDay: _parseBool(json['allow_half_day']),
      requiredAttachment: json['required_attachment']?.toString(),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    return v.toString() == '1' || v.toString().toLowerCase() == 'true';
  }
}

class LeaveTypeFormOptions {
  final List<String> categories;
  final List<String> allocationMethods;
  final List<String> attachmentOptions;

  const LeaveTypeFormOptions({
    required this.categories,
    required this.allocationMethods,
    required this.attachmentOptions,
  });

  factory LeaveTypeFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LeaveTypeFormOptions(
      categories: List<String>.from(data['categories'] ?? []),
      allocationMethods: List<String>.from(data['allocation_methods'] ?? []),
      attachmentOptions: List<String>.from(data['attachment_options'] ?? []),
    );
  }
}

class LeaveTypeFormModel {
  String? encryption;
  String leaveTypeName;
  String? leaveCategory;
  String? leaveDescription;
  bool deductBalance;
  String? allocationMethod;
  bool carryOver;
  bool allowHalfDay;
  String? requiredAttachment;

  LeaveTypeFormModel({
    this.encryption,
    this.leaveTypeName = '',
    this.leaveCategory = 'LEAVE',
    this.leaveDescription,
    this.deductBalance = true,
    this.allocationMethod = 'ANNUAL',
    this.carryOver = false,
    this.allowHalfDay = false,
    this.requiredAttachment = 'OPTIONAL',
  });

  factory LeaveTypeFormModel.fromDetail(LeaveTypeDetailModel detail) {
    final d = detail.leaveType;
    return LeaveTypeFormModel(
      encryption: d.encryption,
      leaveTypeName: d.leaveTypeName,
      leaveCategory: d.leaveCategory ?? 'LEAVE',
      leaveDescription: d.leaveDescription,
      deductBalance: d.deductBalance,
      allocationMethod: d.allocationMethod ?? 'ANNUAL',
      carryOver: d.carryOver,
      allowHalfDay: d.allowHalfDay,
      requiredAttachment: d.requiredAttachment ?? 'OPTIONAL',
    );
  }

  bool isValid() =>
      leaveTypeName.trim().isNotEmpty &&
      leaveCategory != null &&
      allocationMethod != null &&
      requiredAttachment != null;

  Map<String, dynamic> toJson() => {
        'leave_type_name': leaveTypeName,
        'leave_category': leaveCategory,
        'leave_description':
            leaveDescription?.isEmpty == true ? null : leaveDescription,
        'deduct_balance': deductBalance,
        'allocation_method': allocationMethod,
        'carry_over': carryOver,
        'allow_half_day': allowHalfDay,
        'required_attachment': requiredAttachment,
      };
}