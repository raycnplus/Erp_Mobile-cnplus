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

class LeaveRequestModel {
  final String encryption, status;
  final String? startDatetime, endDatetime, createdDate, employeeName, leaveTypeName;
  final double totalDays;

  LeaveRequestModel({
    required this.encryption,
    required this.status,
    required this.totalDays,
    this.startDatetime,
    this.endDatetime,
    this.createdDate,
    this.employeeName,
    this.leaveTypeName,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) => LeaveRequestModel(
        encryption:    json['encryption']?.toString() ?? '',
        status:        json['status']?.toString() ?? '',
        totalDays:     _pd(json['total_days']),
        startDatetime: json['start_datetime']?.toString(),
        endDatetime:   json['end_datetime']?.toString(),
        createdDate:   json['created_date']?.toString(),
        employeeName:  json['employee_name']?.toString(),
        leaveTypeName: json['leave_type_name']?.toString(),
      );
}

class LeaveRequestPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  LeaveRequestPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class LeaveTypeOption {
  final int id;
  final String name, category;
  final bool allowHalfDay, requiredAttachment;

  LeaveTypeOption({
    required this.id,
    required this.name,
    required this.category,
    required this.allowHalfDay,
    required this.requiredAttachment,
  });

  factory LeaveTypeOption.fromJson(Map<String, dynamic> json) => LeaveTypeOption(
        id:                 _pi(json['id_leave_type']),
        name:               json['leave_type_name']?.toString() ?? '',
        category:           json['leave_category']?.toString() ?? '',
        allowHalfDay:       json['allow_half_day'] == 1 || json['allow_half_day'] == true,
        requiredAttachment: json['required_attachment'] == 1 ||
            json['required_attachment'] == true ||
            json['required_attachment'] == 'YES',
      );

  @override bool operator ==(Object o) => o is LeaveTypeOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class LeaveQuotaInfo {
  final int idLeaveType;
  final String leaveTypeName;
  final double totalQuota, totalUsed, totalRemaining;

  LeaveQuotaInfo({
    required this.idLeaveType,
    required this.leaveTypeName,
    required this.totalQuota,
    required this.totalUsed,
    required this.totalRemaining,
  });

  factory LeaveQuotaInfo.fromJson(Map<String, dynamic> json) => LeaveQuotaInfo(
        idLeaveType:    _pi(json['id_leave_type']),
        leaveTypeName:  json['leave_type_name']?.toString() ?? '',
        totalQuota:     _pd(json['total_quota']),
        totalUsed:      _pd(json['total_used']),
        totalRemaining: _pd(json['total_remaining']),
      );
}

class LeaveRequestFormOptions {
  final List<LeaveTypeOption> leaveTypes;
  final List<LeaveQuotaInfo> leaveQuotas;

  LeaveRequestFormOptions({required this.leaveTypes, required this.leaveQuotas});

  factory LeaveRequestFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LeaveRequestFormOptions(
      leaveTypes:  (data['leave_types']  as List? ?? []).map((e) => LeaveTypeOption.fromJson(e)).toList(),
      leaveQuotas: (data['leave_quotas'] as List? ?? []).map((e) => LeaveQuotaInfo.fromJson(e)).toList(),
    );
  }
}

class LeaveAuditTrail {
  final String? actionByName, actionById, description, type, date;

  LeaveAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory LeaveAuditTrail.fromJson(Map<String, dynamic> json) => LeaveAuditTrail(
        actionByName: json['action_by_name']?.toString(),
        actionById: json['action_by']?.toString(),
        description:  json['description']?.toString(),
        type:         json['type']?.toString(),
        date:         json['date']?.toString(),
      );
}

class LeaveRequestDetailModel {
  final int idLeaveRequest;
  final String encryption, status;
  final String? startDatetime, endDatetime, description, durationType, halfSession;
  final double totalDays;
  final int? idLeaveType, idEmployee;
  final String? leaveTypeName, employeeName, createdByName, updatedByName, createdDate, updatedDate, attachmentUrl;
  final List<LeaveAuditTrail> auditTrails;
  final Map<String, dynamic>? approvalInfo;

  LeaveRequestDetailModel({
    required this.idLeaveRequest,
    required this.encryption,
    required this.status,
    required this.totalDays,
    this.startDatetime,
    this.endDatetime,
    this.description,
    this.durationType,
    this.halfSession,
    this.idLeaveType,
    this.idEmployee,
    this.leaveTypeName,
    this.employeeName,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
    this.attachmentUrl,
    required this.auditTrails,
    this.approvalInfo,
  });

  factory LeaveRequestDetailModel.fromJson(Map<String, dynamic> json) {
    final data     = json['data'] ?? json;
    final karyawan = data['karyawan'] ?? data['employee'];
    final empName  = karyawan?['employee_name']?.toString() ?? data['employee_name']?.toString();

    return LeaveRequestDetailModel(
      idLeaveRequest: _pi(data['id_leave_request']),
      encryption:     data['encryption']?.toString() ?? '',
      status:         data['status']?.toString() ?? '',
      totalDays:      _pd(data['total_days']),
      startDatetime:  data['start_datetime']?.toString(),
      endDatetime:    data['end_datetime']?.toString(),
      description:    data['description']?.toString(),
      durationType:   data['duration_type']?.toString(),
      halfSession:    data['half_session']?.toString(),
      idLeaveType:    _pi(data['id_leave_type']) == 0 ? null : _pi(data['id_leave_type']),
      idEmployee:     _pi(data['id_employee']) == 0 ? null : _pi(data['id_employee']),
      leaveTypeName:  data['leave_type']?['leave_type_name']?.toString() ?? data['leave_type_name']?.toString(),
      employeeName:   empName,
      createdByName:  data['created_by_name']?.toString(),
      updatedByName:  data['updated_by_name']?.toString(),
      createdDate:  data['created_date']?.toString(),
      updatedDate:  data['updated_date']?.toString(),
      attachmentUrl:  data['attachment']?.toString(),
      auditTrails:    (data['audit_trails'] as List? ?? []).map((e) => LeaveAuditTrail.fromJson(e)).toList(),
      approvalInfo:   data['approval_info'] is Map
          ? Map<String, dynamic>.from(data['approval_info'] as Map)
          : null,
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get canDelete         => status == 'Draft';
  bool get canEdit           => status == 'Draft';
  bool get canSubmit         => status == 'Draft';
}

class LeaveRequestFormModel {
  int? idLeaveRequest;
  String? encryption;
  int? idLeaveType;
  DateTime? startDate, endDate;
  String durationType;
  String? halfSession;
  String? description;

  LeaveRequestFormModel({
    this.idLeaveRequest,
    this.encryption,
    this.idLeaveType,
    this.startDate,
    this.endDate,
    this.durationType = 'FULL',
    this.halfSession,
    this.description,
  });

  bool get isEditMode => idLeaveRequest != null;

  bool isValid() =>
      idLeaveType != null &&
      startDate != null &&
      (durationType == 'FULL' ? endDate != null : true);

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson({String status = 'save'}) {
    final end = durationType == 'HALF' ? startDate! : (endDate ?? startDate!);
    return {
      if (idLeaveRequest != null) 'id_leave_request': idLeaveRequest,
      'id_leave_type':  idLeaveType,
      'duration_type':  durationType,
      if (halfSession != null) 'half_session': halfSession,
      'start_datetime': _fmtDate(startDate!),
      'end_datetime':   _fmtDate(end),
      if (description != null && description!.isNotEmpty) 'description': description,
      'status':         status,
    };
  }
}