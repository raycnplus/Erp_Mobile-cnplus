class SalesTeamModels {
  final int idPurchaseTeam;
  final String teamName;
  final String teamLeader;
  final String description;

  SalesTeamModels({
    required this.idPurchaseTeam,
    required this.teamName,
    required this.teamLeader,
    required this.description,
  });

  factory SalesTeamModels.fromJson(Map<String, dynamic> json) {
    return SalesTeamModels(
      idPurchaseTeam: json['id_purchase_team'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_purchase_team': idPurchaseTeam,
      'team_name': teamName,
      'team_leader': teamLeader,
      'description': description,
    };
  }
}

class SalesTeamEditModel {
  final int id;
  String teamName;
  int teamLeaderId;
  String description;
  List<int> memberIds;

  SalesTeamEditModel({
    required this.id,
    required this.teamName,
    required this.teamLeaderId,
    required this.description,
    required this.memberIds,
  });

  Map<String, dynamic> toUpdateJson() {
    return {
      'id_purchase_team': id,
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}