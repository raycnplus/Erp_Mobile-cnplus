class EmployeePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  EmployeePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory EmployeePaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return EmployeePaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class EmployeeModel {
  final String encryption;
  final String employeeName;
  final String? gender;
  final String? phoneNumber;
  final String? email;
  final String departmentName;
  final String positionName;
  final String employeeStatusName;
  final String managerName;
  final String? createdDate;

  EmployeeModel({
    required this.encryption,
    required this.employeeName,
    this.gender,
    this.phoneNumber,
    this.email,
    this.departmentName = '-',
    this.positionName = '-',
    this.employeeStatusName = '-',
    this.managerName = '-',
    this.createdDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        encryption: json['encryption']?.toString() ?? '',
        employeeName: json['employee_name']?.toString() ?? '',
        gender: json['gender']?.toString(),
        phoneNumber: json['phone_number']?.toString(),
        email: json['email']?.toString(),
        departmentName: json['department_name']?.toString() ?? '-',
        positionName: json['position_name']?.toString() ?? '-',
        employeeStatusName: json['employee_status_name']?.toString() ?? '-',
        managerName: json['manager_name']?.toString() ?? '-',
        createdDate: json['created_date']?.toString(),
      );
}

class EmployeeDetailModel {
  final EmployeeData employee;
  final bool hasUserAccount;
  final UserAccountData? userDetails;
  final String? createdByName;
  final String? updatedByName;

  EmployeeDetailModel({
    required this.employee,
    this.hasUserAccount = false,
    this.userDetails,
    this.createdByName,
    this.updatedByName,
  });

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return EmployeeDetailModel(
      employee: EmployeeData.fromJson(data),
      hasUserAccount: json['has_user_account'] == true,
      userDetails: json['user_details'] != null
          ? UserAccountData.fromJson(json['user_details'])
          : null,
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class UserAccountData {
  final int? idUser;
  final String? username;
  final String? role;

  UserAccountData({this.idUser, this.username, this.role});

  factory UserAccountData.fromJson(Map<String, dynamic> json) => UserAccountData(
        idUser: json['id_user'] is int
            ? json['id_user']
            : int.tryParse(json['id_user']?.toString() ?? ''),
        username: json['username']?.toString(),
        role: json['role']?.toString(),
      );
}

class EmployeeData {
  final String encryption;
  final String employeeName;
  final String? gender;
  final String? birthDate;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? departmentName;
  final String? positionName;
  final String? employeeStatusName;
  final String? managerName;
  final int? idDepartment;
  final int? idPosition;
  final int? idManager;
  final int? idEmployeeStatus;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountHolder;
  final double? basicSalary;
  final double? allowance;
  final String? ktpNumber;
  final String? npwpNumber;
  final String? bpjsNumber;
  final String? hashedImage;
  final String? hashedKtpFile;
  final String? hashedNpwpFile;
  final String? hashedBpjsFile;
  final String? createdDate;
  final String? updatedDate;

  EmployeeData({
    required this.encryption,
    required this.employeeName,
    this.gender,
    this.birthDate,
    this.phoneNumber,
    this.email,
    this.address,
    this.departmentName,
    this.positionName,
    this.employeeStatusName,
    this.managerName,
    this.idDepartment,
    this.idPosition,
    this.idManager,
    this.idEmployeeStatus,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountHolder,
    this.basicSalary,
    this.allowance,
    this.ktpNumber,
    this.npwpNumber,
    this.bpjsNumber,
    this.hashedImage,
    this.hashedKtpFile,
    this.hashedNpwpFile,
    this.hashedBpjsFile,
    this.createdDate,
    this.updatedDate,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return EmployeeData(
      encryption: json['encryption']?.toString() ?? '',
      employeeName: json['employee_name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      birthDate: json['birth_date']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      departmentName: json['department_name']?.toString(),
      positionName: json['position_name']?.toString(),
      employeeStatusName: json['employee_status_name']?.toString(),
      managerName: json['manager_name']?.toString(),
      idDepartment: parseInt(json['id_department']),
      idPosition: parseInt(json['id_position']),
      idManager: parseInt(json['id_manager']),
      idEmployeeStatus: parseInt(json['id_employee_status']),
      bankName: json['bank_name']?.toString(),
      bankAccountNumber: json['bank_account_number']?.toString(),
      bankAccountHolder: json['bank_account_holder']?.toString(),
      basicSalary: parseDouble(json['basic_salary']),
      allowance: parseDouble(json['allowance']),
      ktpNumber: json['ktp_number']?.toString(),
      npwpNumber: json['npwp_number']?.toString(),
      bpjsNumber: json['bpjs_number']?.toString(),
      hashedImage: json['hashed_image']?.toString(),
      hashedKtpFile: json['hashed_ktp_file']?.toString(),
      hashedNpwpFile: json['hashed_npwp_file']?.toString(),
      hashedBpjsFile: json['hashed_bpjs_file']?.toString(),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class EmployeeDropdownData {
  final List<DeptDropdown> departments;
  final List<PosDropdown> positions;
  final List<EmpStatusDropdown> employeeStatuses;
  final List<ManagerDropdown> managers;
  final List<RoleDropdown> roles;

  EmployeeDropdownData({
    required this.departments,
    required this.positions,
    required this.employeeStatuses,
    required this.managers,
    this.roles = const [],
  });

  factory EmployeeDropdownData.fromJson(Map<String, dynamic> json) =>
      EmployeeDropdownData(
        departments: (json['departments'] as List? ?? [])
            .map((e) => DeptDropdown.fromJson(e))
            .toList(),
        positions: (json['positions'] as List? ?? [])
            .map((e) => PosDropdown.fromJson(e))
            .toList(),
        employeeStatuses: (json['employee_statuses'] as List? ?? [])
            .map((e) => EmpStatusDropdown.fromJson(e))
            .toList(),
        managers: (json['managers'] as List? ?? [])
            .map((e) => ManagerDropdown.fromJson(e))
            .toList(),
        roles: (json['roles'] as List? ?? [])
            .map((e) => RoleDropdown.fromJson(e))
            .toList(),
      );
}

class DeptDropdown {
  final int id;
  final String name;

  DeptDropdown({required this.id, required this.name});

  factory DeptDropdown.fromJson(Map<String, dynamic> json) => DeptDropdown(
        id: int.tryParse(json['id_department']?.toString() ?? '0') ?? 0,
        name: json['department_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is DeptDropdown && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PosDropdown {
  final int id;
  final String name;

  PosDropdown({required this.id, required this.name});

  factory PosDropdown.fromJson(Map<String, dynamic> json) => PosDropdown(
        id: int.tryParse(json['id_position']?.toString() ?? '0') ?? 0,
        name: json['position_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is PosDropdown && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class EmpStatusDropdown {
  final int id;
  final String name;

  EmpStatusDropdown({required this.id, required this.name});

  factory EmpStatusDropdown.fromJson(Map<String, dynamic> json) => EmpStatusDropdown(
        id: int.tryParse(json['id_employee_status']?.toString() ?? '0') ?? 0,
        name: json['employee_status_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is EmpStatusDropdown && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ManagerDropdown {
  final int id;
  final String name;

  ManagerDropdown({required this.id, required this.name});

  factory ManagerDropdown.fromJson(Map<String, dynamic> json) => ManagerDropdown(
        id: int.tryParse(json['id_employee']?.toString() ?? '0') ?? 0,
        name: json['employee_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is ManagerDropdown && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class RoleDropdown {
  final int id;
  final String name;

  RoleDropdown({required this.id, required this.name});

  factory RoleDropdown.fromJson(Map<String, dynamic> json) => RoleDropdown(
        id: int.tryParse(json['id_role']?.toString() ?? '0') ?? 0,
        name: json['role_name']?.toString() ?? '',
      );

  @override
  String toString() => name;

  @override
  bool operator ==(Object o) => o is RoleDropdown && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class EmployeeFormModel {
  String? encryption;
  String employeeName;
  String? gender;
  String? birthDate;
  String? phoneNumber;
  String? email;
  String? address;
  int? idDepartment;
  int? idPosition;
  int? idManager;
  int? idEmployeeStatus;
  String? bankName;
  String? bankAccountNumber;
  String? bankAccountHolder;
  double? basicSalary;
  double? allowance;
  String? ktpNumber;
  String? npwpNumber;
  String? bpjsNumber;
  String? newImagePath;
  String? newKtpFilePath;
  String? newNpwpFilePath;
  String? newBpjsFilePath;
  String? oldHashedImage;
  String? oldHashedKtpFile;
  String? oldHashedNpwpFile;
  String? oldHashedBpjsFile;

  EmployeeFormModel({
    this.encryption,
    this.employeeName = '',
    this.gender,
    this.birthDate,
    this.phoneNumber,
    this.email,
    this.address,
    this.idDepartment,
    this.idPosition,
    this.idManager,
    this.idEmployeeStatus,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountHolder,
    this.basicSalary,
    this.allowance,
    this.ktpNumber,
    this.npwpNumber,
    this.bpjsNumber,
    this.newImagePath,
    this.newKtpFilePath,
    this.newNpwpFilePath,
    this.newBpjsFilePath,
    this.oldHashedImage,
    this.oldHashedKtpFile,
    this.oldHashedNpwpFile,
    this.oldHashedBpjsFile,
  });

  factory EmployeeFormModel.fromDetail(EmployeeDetailModel detail) {
    final e = detail.employee;
    return EmployeeFormModel(
      encryption: e.encryption,
      employeeName: e.employeeName,
      gender: e.gender,
      birthDate: e.birthDate,
      phoneNumber: e.phoneNumber,
      email: e.email,
      address: e.address,
      idDepartment: e.idDepartment,
      idPosition: e.idPosition,
      idManager: e.idManager,
      idEmployeeStatus: e.idEmployeeStatus,
      bankName: e.bankName,
      bankAccountNumber: e.bankAccountNumber,
      bankAccountHolder: e.bankAccountHolder,
      basicSalary: e.basicSalary,
      allowance: e.allowance,
      ktpNumber: e.ktpNumber,
      npwpNumber: e.npwpNumber,
      bpjsNumber: e.bpjsNumber,
      oldHashedImage: e.hashedImage,
      oldHashedKtpFile: e.hashedKtpFile,
      oldHashedNpwpFile: e.hashedNpwpFile,
      oldHashedBpjsFile: e.hashedBpjsFile,
    );
  }

  bool isValid() => employeeName.trim().isNotEmpty;
}