import 'package:equatable/equatable.dart';

class KaryawanDropdownModel extends Equatable {
  final int id;
  final String fullName;

  const KaryawanDropdownModel({required this.id, required this.fullName});

  // [PERBAIKAN] Menggunakan key 'id_karyawan' dan 'nama_lengkap' sesuai JSON
  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_karyawan'],
      fullName: json['nama_lengkap'],
    );
  }

  @override
  List<Object?> get props => [id, fullName];
}