// Ganti seluruh isi file: lib/.../purchase_team/models/purchase_team_models.dart

class PurchaseTeamIndexModel {
  final int idPurchaseTeam;
  final String teamName;
  final String teamLeader;
  final String description;
  final int totalMembers; // ✅ Tambahkan properti ini

  PurchaseTeamIndexModel({
    required this.idPurchaseTeam,
    required this.teamName,
    required this.teamLeader,
    required this.description,
    required this.totalMembers, // ✅ Tambahkan properti ini
  });

  factory PurchaseTeamIndexModel.fromJson(Map<String, dynamic> json) {
    // Hitung jumlah anggota dari list 'member' atau 'members'
    int memberCount = 0;
    if (json['member'] is List) {
      memberCount = (json['member'] as List).length;
    } else if (json['members'] is List) {
      memberCount = (json['members'] as List).length;
    }

    return PurchaseTeamIndexModel(
      idPurchaseTeam: json['id_purchase_team'] ?? 0,
      teamName: json['team_name'] ?? 'No Name',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? 'No Leader',
      description: json['description'] ?? '',
      totalMembers: memberCount, // ✅ Set nilainya di sini
    );
  }
}