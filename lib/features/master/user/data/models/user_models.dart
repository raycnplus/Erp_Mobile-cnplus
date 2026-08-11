class UserPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const UserPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory UserPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return UserPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class UserModel {
  final int idUser;
  final String username;
  final String namaLengkap;
  final String email;
  final String? nomorTelepon;
  final String status;
  final String departmentName;
  final String positionName;
  final String roleName;

  const UserModel({
    required this.idUser,
    required this.username,
    required this.namaLengkap,
    required this.email,
    this.nomorTelepon,
    required this.status,
    required this.departmentName,
    required this.positionName,
    required this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] is int
          ? json['id_user']
          : int.tryParse(json['id_user'].toString()) ?? 0,
      username: json['username']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nomorTelepon: json['nomor_telepon']?.toString(),
      status: json['status']?.toString() ?? 'enable',
      departmentName: json['department_name']?.toString() ?? '-',
      positionName: json['position_name']?.toString() ?? '-',
      roleName: json['role_name']?.toString() ?? '-',
    );
  }

  bool get isEnabled => status == 'enable';
}

class UserDetailModel {
  final UserDetailData user;

  const UserDetailModel({required this.user});

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserDetailModel(user: UserDetailData.fromJson(data));
  }
}

class UserDetailData {
  final int idUser;
  final String username;
  final String namaLengkap;
  final String email;
  final String status;
  final String? nomorTelepon;
  final String? alamat;
  final String? gender;
  final String? employeeName;
  final String departmentName;
  final String positionName;
  final String employeeStatusName;
  final String roleName;

  const UserDetailData({
    required this.idUser,
    required this.username,
    required this.namaLengkap,
    required this.email,
    required this.status,
    this.nomorTelepon,
    this.alamat,
    this.gender,
    this.employeeName,
    required this.departmentName,
    required this.positionName,
    required this.employeeStatusName,
    required this.roleName,
  });

  factory UserDetailData.fromJson(Map<String, dynamic> json) {
    return UserDetailData(
      idUser: json['id_user'] is int
          ? json['id_user']
          : int.tryParse(json['id_user'].toString()) ?? 0,
      username: json['username']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      status: json['status']?.toString() ?? 'enable',
      nomorTelepon: json['nomor_telepon']?.toString(),
      alamat: json['alamat']?.toString(),
      gender: json['gender']?.toString(),
      employeeName: json['employee_name']?.toString(),
      departmentName: json['department_name']?.toString() ?? '-',
      positionName: json['position_name']?.toString() ?? '-',
      employeeStatusName: json['employee_status_name']?.toString() ?? '-',
      roleName: json['role_name']?.toString() ?? '-',
    );
  }

  bool get isEnabled => status == 'enable';
}