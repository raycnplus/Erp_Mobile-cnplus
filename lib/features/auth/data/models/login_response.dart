class LoginResponse {
  final String token;
  final UserData? user;

  LoginResponse({
    required this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final int? idUser;
  final String? username;
  final String? namaLengkap;
  final String? nomorTelepon;
  final String? email;
  final String? alamat;
  final String? image;
  final String? hashedImage;
  final String? gender;
  final String? employeeName;
  final String? departmentName;
  final String? positionName;
  final String? employeeStatusName;

  UserData({
    this.idUser,
    this.username,
    this.namaLengkap,
    this.nomorTelepon,
    this.email,
    this.alamat,
    this.image,
    this.hashedImage,
    this.gender,
    this.employeeName,
    this.departmentName,
    this.positionName,
    this.employeeStatusName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: _parseInt(json['id_user']),
      username: json['username'] as String?,
      namaLengkap: json['nama_lengkap'] as String?,
      nomorTelepon: json['nomor_telepon'] as String?,
      email: json['email'] as String?,
      alamat: json['alamat'] as String?,
      image: json['image'] as String?,
      hashedImage: json['hashed_image'] as String?,
      gender: json['gender'] as String?,
      employeeName: json['employee_name'] as String?,
      departmentName: json['department_name'] as String?,
      positionName: json['position_name'] as String?,
      employeeStatusName: json['employee_status_name'] as String?,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'nama_lengkap': namaLengkap,
      'nomor_telepon': nomorTelepon,
      'email': email,
      'alamat': alamat,
      'image': image,
      'hashed_image': hashedImage,
      'gender': gender,
      'employee_name': employeeName,
      'department_name': departmentName,
      'position_name': positionName,
      'employee_status_name': employeeStatusName,
    };
  }
}