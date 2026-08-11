class LeaveAllocationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LeaveAllocationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LeaveAllocationPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return LeaveAllocationPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class LeaveAllocationModel {
  final String encryption;
  final String allocationName;
  final int year;
  final double quota;
  final String leaveType;

  LeaveAllocationModel({
    required this.encryption,
    required this.allocationName,
    required this.year,
    required this.quota,
    required this.leaveType,
  });

  factory LeaveAllocationModel.fromJson(Map<String, dynamic> json) =>
      LeaveAllocationModel(
        encryption: json['encryption']?.toString() ?? '',
        allocationName: json['allocation_name']?.toString() ?? '',
        year: int.tryParse(json['year']?.toString() ?? '0') ?? 0,
        quota: double.tryParse(json['quota']?.toString() ?? '0') ?? 0,
        leaveType: json['leave_type']?.toString() ?? '-',
      );
}

class LeaveAllocationDetailRow {
  final int? idEmployee;
  final int? idPosition;
  final int? idDepartment;
  final String nama;
  final double quota;
  final double used;
  final double remaining;

  LeaveAllocationDetailRow({
    this.idEmployee,
    this.idPosition,
    this.idDepartment,
    required this.nama,
    required this.quota,
    required this.used,
    required this.remaining,
  });

  factory LeaveAllocationDetailRow.fromJson(Map<String, dynamic> json) =>
      LeaveAllocationDetailRow(
        idEmployee: json['id_employee'] is int
            ? json['id_employee']
            : int.tryParse(json['id_employee']?.toString() ?? ''),
        idPosition: json['id_position'] is int
            ? json['id_position']
            : int.tryParse(json['id_position']?.toString() ?? ''),
        idDepartment: json['id_department'] is int
            ? json['id_department']
            : int.tryParse(json['id_department']?.toString() ?? ''),
        nama: json['nama']?.toString() ?? '',
        quota: double.tryParse(json['quota']?.toString() ?? '0') ?? 0,
        used: double.tryParse(json['used']?.toString() ?? '0') ?? 0,
        remaining: double.tryParse(json['remaining']?.toString() ?? '0') ?? 0,
      );
}

class LeaveAllocationDetailModel {
  final String encryption;
  final String allocationName;
  final int year;
  final double quota;
  final String allocationBy;
  final int? idLeaveType;
  final String? leaveTypeName;
  final int totalEmployees;
  final List<LeaveAllocationDetailRow> details;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;

  LeaveAllocationDetailModel({
    required this.encryption,
    required this.allocationName,
    required this.year,
    required this.quota,
    required this.allocationBy,
    this.idLeaveType,
    this.leaveTypeName,
    required this.totalEmployees,
    required this.details,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
  });

  factory LeaveAllocationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return LeaveAllocationDetailModel(
      encryption: data['encryption']?.toString() ?? '',
      allocationName: data['allocation_name']?.toString() ?? '',
      year: int.tryParse(data['year']?.toString() ?? '0') ?? 0,
      quota: double.tryParse(data['quota']?.toString() ?? '0') ?? 0,
      allocationBy: data['allocation_by']?.toString() ?? 'ALL',
      idLeaveType: data['id_leave_type'] is int
          ? data['id_leave_type']
          : int.tryParse(data['id_leave_type']?.toString() ?? ''),
      leaveTypeName: data['leave_type_name']?.toString(),
      totalEmployees: int.tryParse(data['total_employees']?.toString() ?? '0') ?? 0,
      details: (data['details'] as List? ?? [])
          .map((e) => LeaveAllocationDetailRow.fromJson(e))
          .toList(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class LeaveAllocationFormOptions {
  final List<EmpOption> employees;
  final List<PosOption> positions;
  final List<DeptOption> departments;
  final List<LtOption> leaveTypes;
  final List<String> allocationByOptions;

  LeaveAllocationFormOptions({
    required this.employees,
    required this.positions,
    required this.departments,
    required this.leaveTypes,
    required this.allocationByOptions,
  });

  factory LeaveAllocationFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LeaveAllocationFormOptions(
      employees: (data['employees'] as List? ?? [])
          .map((e) => EmpOption.fromJson(e))
          .toList(),
      positions: (data['positions'] as List? ?? [])
          .map((e) => PosOption.fromJson(e))
          .toList(),
      departments: (data['departments'] as List? ?? [])
          .map((e) => DeptOption.fromJson(e))
          .toList(),
      leaveTypes: (data['leave_types'] as List? ?? [])
          .map((e) => LtOption.fromJson(e))
          .toList(),
      allocationByOptions: List<String>.from(
        data['allocation_by_options'] ?? ['ALL', 'EMPLOYEE', 'DEPARTMENT', 'POSITION'],
      ),
    );
  }
}

class EmpOption {
  final int id;
  final String name;

  EmpOption({required this.id, required this.name});

  factory EmpOption.fromJson(Map<String, dynamic> json) => EmpOption(
        id: int.tryParse(json['id_employee']?.toString() ?? '0') ?? 0,
        name: json['employee_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is EmpOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PosOption {
  final int id;
  final String name;

  PosOption({required this.id, required this.name});

  factory PosOption.fromJson(Map<String, dynamic> json) => PosOption(
        id: int.tryParse(json['id_position']?.toString() ?? '0') ?? 0,
        name: json['position_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is PosOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DeptOption {
  final int id;
  final String name;

  DeptOption({required this.id, required this.name});

  factory DeptOption.fromJson(Map<String, dynamic> json) => DeptOption(
        id: int.tryParse(json['id_department']?.toString() ?? '0') ?? 0,
        name: json['department_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is DeptOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class LtOption {
  final int id;
  final String name;

  LtOption({required this.id, required this.name});

  factory LtOption.fromJson(Map<String, dynamic> json) => LtOption(
        id: int.tryParse(json['id_leave_type']?.toString() ?? '0') ?? 0,
        name: json['leave_type_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is LtOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class LeaveAllocationDetailItem {
  final int id;
  final String name;
  double quota;

  LeaveAllocationDetailItem({
    required this.id,
    required this.name,
    required this.quota,
  });
}

class LeaveAllocationFormModel {
  String? encryption;
  String allocationName;
  int? year;
  int? idLeaveType;
  double quota;
  String allocationBy;
  List<LeaveAllocationDetailItem> selectedDetails;

  LeaveAllocationFormModel({
    this.encryption,
    this.allocationName = '',
    this.year,
    this.idLeaveType,
    this.quota = 12,
    this.allocationBy = 'ALL',
    List<LeaveAllocationDetailItem>? selectedDetails,
  }) : selectedDetails = selectedDetails ?? [];

  bool isValid() =>
      allocationName.trim().isNotEmpty &&
      year != null &&
      idLeaveType != null &&
      quota > 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'allocation_name': allocationName,
      'year': year,
      'id_leave_type': idLeaveType,
      'quota': quota,
      'allocation_by': allocationBy,
    };
    if (allocationBy != 'ALL') {
      map['details'] = selectedDetails
          .map((d) => {'id': d.id, 'quota': d.quota})
          .toList();
    }
    return map;
  }
}