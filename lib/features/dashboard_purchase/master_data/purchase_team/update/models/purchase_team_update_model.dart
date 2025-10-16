// Ganti seluruh isi file purchase_team_update_model.dart

class PurchaseTeamUpdateModel {
  final int idPurchaseTeam;
  final String teamName;
  final int? teamLeaderId;
  final String? description;
  final List<int> memberIds;

  PurchaseTeamUpdateModel({
    required this.idPurchaseTeam,
    required this.teamName,
    this.teamLeaderId,
    this.description,
    required this.memberIds,
  });

  factory PurchaseTeamUpdateModel.fromJson(Map<String, dynamic> json) {
    List<int> members = [];
    if (json['member'] is List) {
      members = (json['member'] as List<dynamic>)
          .map<int?>((m) => m?['karyawan']?['id_karyawan'] as int?)
          .whereType<int>()
          .toList();
    } else if (json['members'] is List) { // Fallback jika kuncinya 'members'
      members = (json['members'] as List<dynamic>)
          .map<int?>((m) => m?['id_karyawan'] as int?)
          .whereType<int>()
          .toList();
    }

    return PurchaseTeamUpdateModel(
      idPurchaseTeam: json['id_purchase_team'] as int? ?? 0,
      teamName: json['team_name'] as String? ?? '',
      teamLeaderId: json['team_leader']?['id_karyawan'] as int?,
      description: json['description'] as String?,
      memberIds: members,
    );
  }
}

// CLASS KARYAWAN DROPDOWN MODEL YANG DUPLIKAT SUDAH DIHAPUS DARI SINI