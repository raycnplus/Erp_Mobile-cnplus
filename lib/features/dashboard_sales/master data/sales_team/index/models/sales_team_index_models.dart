// sales_team_models.dart

class SalesTeamModels {
  final int idSalesTeam; // <-- Diubah dari idPurchaseTeam
  final String teamName;
  final String teamLeader;
  final String description;

  SalesTeamModels({
    required this.idSalesTeam, // <-- Diubah
    required this.teamName,
    required this.teamLeader,
    required this.description,
  });

  factory SalesTeamModels.fromJson(Map<String, dynamic> json) {
    return SalesTeamModels(
      idSalesTeam: json['id_sales_team'] ?? 0, // <-- Kunci JSON diperbaiki
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sales_team': idSalesTeam, // <-- Diubah
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
      'id_sales_team': id, // <-- Diubah dari id_purchase_team
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}