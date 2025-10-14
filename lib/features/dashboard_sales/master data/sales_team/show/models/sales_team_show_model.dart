// lib/features/dashboard_sales/master data/sales_team/index/models/sales_team_index_models.dart

class SalesTeamModels {
  final int idSalesTeam;
  final String teamName;
  final String teamLeader;
  final String teamLeaderName;
  final String description;
  final int totalMembers;
  final List<String> memberNames;
  final String createdDate;

  SalesTeamModels({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeader,
    required this.teamLeaderName,
    required this.description,
    required this.totalMembers,
    required this.memberNames,
    required this.createdDate,
  });

  factory SalesTeamModels.fromJson(Map<String, dynamic> json) {
    // Extract member names from members array
    final List<dynamic> members = json['members'] ?? [];
    final List<String> memberNames = members
        .map((member) => member['nama_lengkap'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return SalesTeamModels(
      idSalesTeam: json['id_sales_team'] ?? 0,
      teamName: json['team_name'] ?? 'No Name',
      teamLeader: json['team_leader'] ?? 'No Leader',
      teamLeaderName: json['team_leader'] ?? 'No Leader Name', // team_leader digunakan juga sebagai teamLeaderName
      description: json['description'] ?? '',
      totalMembers: members.length,
      memberNames: memberNames,
      createdDate: json['created_on'] ?? '-',
    );
  }
}