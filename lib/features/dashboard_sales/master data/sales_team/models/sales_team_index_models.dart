class PurchaseTeamIndexModel {
  final int idSalesTeam;
  final String teamName;
  final String teamLeader;
  final String description;

  PurchaseTeamIndexModel({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeader,
    required this.description,
  });

  factory PurchaseTeamIndexModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamIndexModel(
      idSalesTeam: json['id_sales_team'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_purchase_team': idSalesTeam,
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
      'id_sales_team': id,
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}