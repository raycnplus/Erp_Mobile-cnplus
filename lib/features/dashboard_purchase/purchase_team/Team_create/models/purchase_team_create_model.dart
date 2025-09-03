class PurchaseTeamCreateModel {
  final String teamName;
  final int teamLeaderId;
  final String description;
  final List<int> memberIds;

  PurchaseTeamCreateModel({
    required this.teamName,
    required this.teamLeaderId,
    required this.description,
    required this.memberIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}

class KaryawanDropdownModel {
  final int id;
  final String fullName;

  KaryawanDropdownModel({
    required this.id,
    required this.fullName,
  });

  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_karyawan'] ?? 0,
      fullName: json['nama_lengkap'] ?? '',
    );
  }

  @override
  String toString() => fullName;
}