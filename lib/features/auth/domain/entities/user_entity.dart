class UserEntity {
  final int idUser;
  final String username;
  final String namaLengkap;
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

  UserEntity({
    required this.idUser,
    required this.username,
    required this.namaLengkap,
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

  String get displayName => namaLengkap.isNotEmpty ? namaLengkap : username;

  String get fullImageUrl {
    if (hashedImage != null && hashedImage!.isNotEmpty) {
      return 'https://erp.cnersia.com/api/user/image/$hashedImage';
    }
    return '';
  }

  bool get hasProfileImage => image != null && image!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'username': username,
      'namaLengkap': namaLengkap,
      'nomorTelepon': nomorTelepon,
      'email': email,
      'alamat': alamat,
      'image': image,
      'hashedImage': hashedImage,
      'gender': gender,
      'employeeName': employeeName,
      'departmentName': departmentName,
      'positionName': positionName,
      'employeeStatusName': employeeStatusName,
    };
  }
}
