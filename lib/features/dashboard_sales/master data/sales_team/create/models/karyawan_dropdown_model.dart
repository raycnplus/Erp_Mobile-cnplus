// Ganti isi file karyawan_dropdown_model.dart

class KaryawanDropdownModel {
  final int id;
  final String fullName;

  KaryawanDropdownModel({
    required this.id,
    required this.fullName,
  });

  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_user'] ?? json['id'] ?? 0,
      fullName: json['nama_lengkap'] ?? json['fullName'] ?? '',
    );
  }

  @override
  String toString() => fullName;
}