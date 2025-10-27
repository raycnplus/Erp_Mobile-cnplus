// Ganti seluruh isi file karyawan_dropdown_model.dart

class KaryawanDropdownModel {
  final int id;
  final String fullName;

  KaryawanDropdownModel({
    required this.id,
    required this.fullName,
  });

  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_user'] as int,
      fullName: json['nama_lengkap'] as String,
    );
  }
}