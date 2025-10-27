// Ganti isi file karyawan_dropdowns_models.dart

import 'package:equatable/equatable.dart';

class KaryawanDropdownModel extends Equatable {
  final int id;
  final String fullName;

  const KaryawanDropdownModel({required this.id, required this.fullName});

  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_user'] ?? json['id'] ?? 0,
      fullName: json['nama_lengkap'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName];
}