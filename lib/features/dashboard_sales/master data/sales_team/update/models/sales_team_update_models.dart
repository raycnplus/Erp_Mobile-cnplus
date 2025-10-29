//  isi file sales_team_update_models.dart

class SalesTeamUpdateModel {
  final int idSalesTeam;
  final String teamName;
  final String teamLeaderName; 
  final String? description;
  final List<int> memberIds;

  SalesTeamUpdateModel({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeaderName,
    this.description,
    required this.memberIds,
  });

  factory SalesTeamUpdateModel.fromJson(Map<String, dynamic> json) {
    final List<int> members = (json['members'] as List<dynamic>?)
            ?.map<int?>((item) => item is Map ? item['id_user'] as int? : null)
            .whereType<int>()
            .toList() ??
        [];

    return SalesTeamUpdateModel(
      idSalesTeam: json['id_sales_team'] as int,
      teamName: json['team_name'] as String? ?? '',
      // Ambil nama leader langsung dari key "team_leader"
      teamLeaderName: json['team_leader'] as String? ?? '',
      description: json['description'] as String?,
      memberIds: members,
    );
  }
}