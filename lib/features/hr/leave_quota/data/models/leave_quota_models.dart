double _pd(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

int _pi(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
}

class LeaveQuotaModel {
  final String employeeName;
  final String employeeEncryption;
  final String leaveTypeName;
  final int idLeaveType;
  final String period;
  final double totalQuota;
  final double totalUsed;
  final double totalRemaining;
  final String? quotaFormatted;
  final String? usedFormatted;
  final String? remainingFormatted;

  LeaveQuotaModel({
    required this.employeeName,
    required this.employeeEncryption,
    required this.leaveTypeName,
    required this.idLeaveType,
    required this.period,
    required this.totalQuota,
    required this.totalUsed,
    required this.totalRemaining,
    this.quotaFormatted,
    this.usedFormatted,
    this.remainingFormatted,
  });

  factory LeaveQuotaModel.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaModel(
      employeeName: json['employee_name']?.toString() ?? '',
      employeeEncryption:
          json['employee_encryption']?.toString() ?? '',
      leaveTypeName: json['leave_type_name']?.toString() ?? '',
      idLeaveType: _pi(json['id_leave_type']),
      period: json['period']?.toString() ?? '',
      totalQuota: _pd(json['total_quota']),
      totalUsed: _pd(json['total_used']),
      totalRemaining: _pd(json['total_remaining']),
      quotaFormatted: json['quota_formatted']?.toString(),
      usedFormatted: json['used_formatted']?.toString(),
      remainingFormatted:
          json['remaining_formatted']?.toString(),
    );
  }

  double get usagePercent {
    if (totalQuota <= 0) {
      return 0.0;
    }

    return (totalUsed / totalQuota).clamp(0.0, 1.0);
  }
}

class LeaveQuotaPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LeaveQuotaPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class LeaveHistoryModel {
  final String encryption;
  final String status;
  final String? startDatetime;
  final String? endDatetime;
  final String? createdDate;
  final String? approvalDate;
  final String? approverName;
  final String? approvalNotes;
  final String? leaveTypeName;
  final String? description;
  final double totalDays;

  LeaveHistoryModel({
    required this.encryption,
    required this.status,
    required this.totalDays,
    this.startDatetime,
    this.endDatetime,
    this.createdDate,
    this.approvalDate,
    this.approverName,
    this.approvalNotes,
    this.leaveTypeName,
    this.description,
  });

  factory LeaveHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeaveHistoryModel(
      encryption: json['encryption']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalDays: _pd(json['total_days']),
      startDatetime: json['start_datetime']?.toString(),
      endDatetime: json['end_datetime']?.toString(),
      createdDate: json['created_date']?.toString(),
      approvalDate: json['approval_date']?.toString(),
      approverName: json['approver_name']?.toString(),
      approvalNotes: json['approval_notes']?.toString(),
      leaveTypeName: json['leave_type_name']?.toString(),
      description: json['description']?.toString(),
    );
  }
}