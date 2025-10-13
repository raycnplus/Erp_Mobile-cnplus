
class SalesTeamModels {
  final int idSalesTeam;
  final String teamName;
  final String teamLeader;
  final String description;
  final int totalMembers; 

  SalesTeamModels({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeader,
    required this.description,
    required this.totalMembers, 
  });

  factory SalesTeamModels.fromJson(Map<String, dynamic> json) {
    return SalesTeamModels(
      idSalesTeam: json['id_sales_team'] ?? 0,
      teamName: json['team_name'] ?? 'No Name',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? 'No Leader',
      description: json['description'] ?? '',
      totalMembers: json['total_members'] ?? 0, 
    );
  }
}