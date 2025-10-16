// Ganti seluruh isi file karyawan_dropdown_model.dart

class KaryawanDropdownModel {
  final int id;
  final String fullName;

  KaryawanDropdownModel({
    required this.id,
    required this.fullName,
  });

  // [PERBAIKAN] Disederhanakan agar sesuai dengan format API yang pasti
  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_karyawan'] as int,
      fullName: json['nama_lengkap'] as String,
    );
  }
}