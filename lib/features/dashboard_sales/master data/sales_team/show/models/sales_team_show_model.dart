class SalesTeamShowModel {
  final int idSalesTeam;
  final String teamName;
  final String teamLeaderName;
  final String description;
  final String createdDate;
  final int createdBy;
  final List<String> memberNames;

 SalesTeamShowModel({
    required this.idSalesTeam,
    required this.teamName,
    required this.teamLeaderName,
    required this.description,
    required this.createdDate,
    required this.createdBy,
    required this.memberNames,
  });

  factory SalesTeamShowModel.fromJson(Map<String, dynamic> json) {
    return SalesTeamShowModel(
      idSalesTeam: json['id_sales_team'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamLeaderName: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
      createdDate: json['created_date'] ?? '',
      createdBy: json['created_by'] ?? 0,
      memberNames: ((json['member'] as List<dynamic>?) ?? [])
          .map<String>((m) => m['karyawan']?['nama_lengkap']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sales_team': idSalesTeam,
      'team_name': teamName,
      'team_leader_name': teamLeaderName,
      'description': description,
      'created_date': createdDate,
      'created_by': createdBy,
      'member_names': memberNames,
    };
  }
}