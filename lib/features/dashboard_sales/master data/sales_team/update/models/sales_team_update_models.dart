 class SalesTeamUpdateModel {
  final int idSalesTeam;
  final String teamName;
  final int? teamLeaderId;
  final String? description;
  final List<int> memberIds;

  SalesTeamUpdateModel({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeaderId,
    required this.description,
    required this.memberIds,
  });

  factory SalesTeamUpdateModel.fromJson(Map<String, dynamic> json) {
    return SalesTeamUpdateModel(
      idSalesTeam: json['id_sales_team'],
      teamName: json['team_name'] ?? '',
      teamLeaderId: json['team_leader']?['id_karyawan'],
      description: json['description'],
      memberIds: (json['member'] as List<dynamic>)
          .map((m) => m['karyawan']['id_karyawan'] as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds,
    };
  }
}
 