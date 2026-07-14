import 'package:flutter/material.dart';

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

class OvertimeRequestModel {
  final String encryption;
  final String status;
  final String? requestDate;
  final String? startDatetime;
  final String? endDatetime;
  final String? employeeName;
  final String? overtimeTypeName;
  final double requestedHours;
  final double approvedHours;

  OvertimeRequestModel({
    required this.encryption,
    required this.status,
    required this.requestedHours,
    required this.approvedHours,
    this.requestDate,
    this.startDatetime,
    this.endDatetime,
    this.employeeName,
    this.overtimeTypeName,
  });

  factory OvertimeRequestModel.fromJson(Map<String, dynamic> j) => OvertimeRequestModel(
        encryption: j['encryption']?.toString() ?? '',
        status: j['status']?.toString() ?? '',
        requestedHours: _pd(j['requested_hours']),
        approvedHours: _pd(j['approved_hours']),
        requestDate: j['request_date_formatted']?.toString() ?? j['request_date']?.toString(),
        startDatetime: j['start_datetime_formatted']?.toString() ?? j['start_datetime']?.toString(),
        endDatetime: j['end_datetime_formatted']?.toString() ?? j['end_datetime']?.toString(),
        employeeName: j['employee_name']?.toString(),
        overtimeTypeName: j['overtime_type_name']?.toString(),
      );
}

class OvertimeRequestPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  OvertimeRequestPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class OvertimeAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  OvertimeAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory OvertimeAuditTrail.fromJson(Map<String, dynamic> j) => OvertimeAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class OvertimeRequestDetailModel {
  final int idOvertimeRequest;
  final String encryption;
  final String status;
  final double requestedHours;
  final double approvedHours;
  final String? requestDate;
  final String? startDatetime;
  final String? endDatetime;
  final String? reason;
  final int? idOvertimeType;
  final int? idEmployee;
  final String? overtimeTypeName;
  final String? employeeName;
  final String? createdByName;
  final List<OvertimeAuditTrail> auditTrails;
  final Map<String, dynamic>? approvalInfo;

  OvertimeRequestDetailModel({
    required this.idOvertimeRequest,
    required this.encryption,
    required this.status,
    required this.requestedHours,
    required this.approvedHours,
    this.requestDate,
    this.startDatetime,
    this.endDatetime,
    this.reason,
    this.idOvertimeType,
    this.idEmployee,
    this.overtimeTypeName,
    this.employeeName,
    this.createdByName,
    required this.auditTrails,
    this.approvalInfo,
  });

  factory OvertimeRequestDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final karyawan = data['employee'] ?? data['karyawan'];
    final empName = karyawan?['employee_name']?.toString() ?? data['employee_name']?.toString();

    return OvertimeRequestDetailModel(
      idOvertimeRequest: _pi(data['id_overtime_request']),
      encryption: data['encryption']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      requestedHours: _pd(data['requested_hours']),
      approvedHours: _pd(data['approved_hours']),
      requestDate: data['request_date']?.toString(),
      startDatetime: data['start_datetime']?.toString(),
      endDatetime: data['end_datetime']?.toString(),
      reason: data['reason']?.toString(),
      idOvertimeType: _pi(data['id_overtime_type']) == 0 ? null : _pi(data['id_overtime_type']),
      idEmployee: _pi(data['id_employee']) == 0 ? null : _pi(data['id_employee']),
      overtimeTypeName: data['overtime_type']?['overtime_type_name']?.toString() ??
          data['overtime_type_name']?.toString(),
      employeeName: empName,
      createdByName: data['created_by_name']?.toString(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => OvertimeAuditTrail.fromJson(e))
          .toList(),
      approvalInfo:
          data['approval_info'] is Map ? Map<String, dynamic>.from(data['approval_info'] as Map) : null,
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get canEdit => status == 'Draft' || status == 'Rejected';
  bool get canDelete => status == 'Draft';
  bool get canSubmit => status == 'Draft';
  bool get canSubmitAfterEdit => status == 'Draft';
}

class OvertimeTypeOption {
  final int id;
  final String name;
  final String category;
  final double rate;

  OvertimeTypeOption({
    required this.id,
    required this.name,
    required this.category,
    required this.rate,
  });

  factory OvertimeTypeOption.fromJson(Map<String, dynamic> j) => OvertimeTypeOption(
        id: _pi(j['id_overtime_type']),
        name: j['overtime_type_name']?.toString() ?? '',
        category: j['overtime_category']?.toString() ?? '',
        rate: _pd(j['overtime_rate']),
      );

  @override
  bool operator ==(Object o) => o is OvertimeTypeOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class OvertimeRequestFormOptions {
  final List<OvertimeTypeOption> overtimeTypes;
  final int? currentEmployeeId;
  final String? currentEmployeeName;

  OvertimeRequestFormOptions({
    required this.overtimeTypes,
    this.currentEmployeeId,
    this.currentEmployeeName,
  });

  factory OvertimeRequestFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final cur = data['current_employee'];
    return OvertimeRequestFormOptions(
      overtimeTypes: (data['overtime_types'] as List? ?? [])
          .map((e) => OvertimeTypeOption.fromJson(e))
          .toList(),
      currentEmployeeId: cur != null ? _pi(cur['id_employee']) : null,
      currentEmployeeName: cur?['employee_name']?.toString(),
    );
  }
}

class OvertimeRequestFormModel {
  int? idOvertimeRequest;
  String? encryption;
  int? idOvertimeType;
  int? idEmployee;
  DateTime? requestDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double requestedHours;
  String? reason;

  OvertimeRequestFormModel({
    this.idOvertimeRequest,
    this.encryption,
    this.idOvertimeType,
    this.idEmployee,
    this.requestDate,
    this.startTime,
    this.endTime,
    this.requestedHours = 0,
    this.reason,
  });

  bool get isEditMode => idOvertimeRequest != null;

  bool isValid() =>
      idOvertimeType != null &&
      idEmployee != null &&
      requestDate != null &&
      startTime != null &&
      endTime != null &&
      requestedHours >= 3;

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson({String actionType = 'save'}) => {
        if (idOvertimeRequest != null) 'id_overtime_request': idOvertimeRequest,
        'id_overtime_type': idOvertimeType,
        'id_employee': idEmployee,
        'request_date': requestDate != null ? _fmtDate(requestDate!) : null,
        'start_time': startTime != null ? _fmtTime(startTime!) : null,
        'end_time': endTime != null ? _fmtTime(endTime!) : null,
        'requested_hours': requestedHours,
        if (reason != null && reason!.isNotEmpty) 'reason': reason,
        'action_type': actionType,
      };
}